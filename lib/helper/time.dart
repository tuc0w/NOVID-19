
/// @author Evan Chu
/// https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss/60904049#60904049
/// 
/// Returns a formatted string for the given Duration [d] to be DD:HH:mm:ss
/// and ignore if 0.
String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds~/Duration.secondsPerDay;
    seconds -= days*Duration.secondsPerDay;
    final hours = seconds~/Duration.secondsPerHour;
    seconds -= hours*Duration.secondsPerHour;
    final minutes = seconds~/Duration.secondsPerMinute;
    seconds -= minutes*Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
        tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0){
        tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
        tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
}

DateTime getCurrentDateTime() {
    return DateTime.now();
}

DateTime getTimeFifteenMinutesAgo() {
    final now = getCurrentDateTime();
    return now.subtract(Duration(minutes: 15));
}

DateTime getLastMidnight() {
    final now = getCurrentDateTime();
    return DateTime(now.year, now.month, now.day);
}
