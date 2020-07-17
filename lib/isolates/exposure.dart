// part of '../main.dart';

// // This needs to be a top-level method because it's run on a background isolate
// DatabaseConnection _backgroundConnection() {
//     // construct the database. You can also wrap the VmDatabase in a "LazyDatabase" if you need to run
//     // work before the database opens.
//     final database = VmDatabase.memory();
//     return DatabaseConnection.fromExecutor(database);
// }

// void main() async {
//     // create a moor executor in a new background isolate. If you want to start the isolate yourself, you
//     // can also call MoorIsolate.inCurrent() from the background isolate
//     MoorIsolate isolate = await MoorIsolate.spawn(_backgroundConnection);

//     // we can now create a database connection that will use the isolate internally. This is NOT what's
//     // returned from _backgroundConnection, moor uses an internal proxy class for isolate communication.
//     DatabaseConnection connection = await isolate.connect();

//     final db = Database.connect(connection);

//     // you can now use your database exactly like you regularly would, it transparently uses a 
//     // background isolate internally
// }
