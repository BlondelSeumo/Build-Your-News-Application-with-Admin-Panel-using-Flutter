
class Config{
  final String appName = 'News Hour'; //app name

  //testing purpose - don't use this password
  final String testerPassword = 'tester12345';  //testing password - don't use this password in the database (you can change this testing password too)

  //firebase server token for push notication
  final String serverToken = 'AAAA5nyi4pE:APA91bG6b0k**************';
  final String icon = 'assets/images/icon.png'; // app icon

  
  
  
  //don't edit or remove this
  final List contentTypes = [
    'image',
    'video'
  ];
}