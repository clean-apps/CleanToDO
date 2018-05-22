
class UserData {

  String userName;
  String abbr;

  UserData( String pUsername ){

    this.userName = pUsername;
    List<String> userNameLst = userName.split(" ");
    if( userNameLst.length == 1 ){
      abbr = userName.substring(0,1).toUpperCase();

    } else {
      abbr = userNameLst.first.substring(0,1).toUpperCase() +
          userNameLst.last.substring(0,1).toUpperCase();
    }

  }

}