class DateUtils {

  static String formatDateTime(DateTime datetime) {
    final date = formatDate(datetime);
    final time = formatTime(datetime);
    
    return  '$date $time';
  }

  static String formatDate(DateTime datetime) {
    final month = datetime.month.toString().padLeft(2,'0');
    final day = datetime.day.toString().padLeft(2,'0');

    return '$day/$month';
  }

  static String formatTime(DateTime datetime) {
    final hour12 = datetime.hour==12 ? 12 : datetime.hour%12;
    final hour = hour12.toString().padLeft(2,'0');
    final format12 = datetime.hour>=12? 'PM': 'AM';
    final minutes = datetime.minute.toString().padLeft(2,'0');
    return '$hour:$minutes $format12';
  }

  static String fechaCreado(DateTime datetime) {    
    if(esHoy(datetime))
      return formatTime(datetime);
    else
      return formatDate(datetime);
  }

  static bool esHoy(DateTime datetime) {
    final hoy = DateTime.now();
    return (hoy.day == datetime.day && hoy.month == datetime.month && hoy.year == datetime.year);
  }
}