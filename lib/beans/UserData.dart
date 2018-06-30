
class UserData {

  String userName;
  String email;
  String abbr;

  UserData( String pUsername, String pEmail ){

    this.userName = pUsername;
    this.email = pEmail;

    if( userName == null ){
      abbr = null;

    } else {

      List<String> userNameLst = userName.split(" ");
      if (userNameLst.length == 1) {
        abbr = userName.substring(0, 1).toUpperCase();

      } else {
        abbr = userNameLst.first.substring(0, 1).toUpperCase() +
            userNameLst.last.substring(0, 1).toUpperCase();
      }

    }

  }

}