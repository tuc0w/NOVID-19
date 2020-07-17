
part of '../main.dart';

Future<MoorIsolate> _createMoorIsolate() async {
    // this method is called from the main isolate. Since we can't use
    // getApplicationDocumentsDirectory on a background isolate, we calculate
    // the database path in the foreground isolate and then inform the
    // background isolate about the path.
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'db.sqlite');
    final receivePort = ReceivePort();

    await Isolate.spawn(
        _startBackground,
        _IsolateStartRequest(receivePort.sendPort, path),
    );

    // _startBackground will send the MoorIsolate to this ReceivePort
    return (await receivePort.first as MoorIsolate);
}

void _startBackground(_IsolateStartRequest request) {
    // this is the entry point from the background isolate! Let's create
    // the database from the path we received
    final executor = VmDatabase(File(request.targetPath));
    // we're using MoorIsolate.inCurrent here as this method already runs on a
    // background isolate. If we used MoorIsolate.spawn, a third isolate would be
    // started which is not what we want!
    final moorIsolate = MoorIsolate.inCurrent(
        () => moor.DatabaseConnection.fromExecutor(executor),
    );
    // inform the starting isolate about this, so that it can call .connect()
    request.sendMoorIsolate.send(moorIsolate);
}

// used to bundle the SendPort and the target path, since isolate entry point
// functions can only take one parameter.
class _IsolateStartRequest {
    final SendPort sendMoorIsolate;
    final String targetPath;

    _IsolateStartRequest(this.sendMoorIsolate, this.targetPath);
}
