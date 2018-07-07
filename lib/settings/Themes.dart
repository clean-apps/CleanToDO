import 'package:flutter/material.dart';

enum AppColors {
                  BLUE, INDIGO, CYAN, TEAL,
                  BROWN, PURPLE, DEEP_PURPLE, AMBER,
                  RED, PINK, GREY, BLUE_GREY,
                  BLACK
              }

class Themes {

  static get( colorId ){

    Iterable<AppColors> provided = AppColors.values.where( (AppColors color) => color.index.toString() == colorId );

    if( provided == null || provided.length == 0 ) return all[ AppColors.BLUE ];
    return all[provided.first];
  }

  static ThemeData _createTheme( Color primary, Color error ){
    return new ThemeData (
      primaryColor: primary,
      buttonColor: primary,
      accentColor: primary,
      primaryColorLight: primary,
      errorColor: error,
      highlightColor: primary.withOpacity( 0.7 ),

      iconTheme: new IconThemeData(
        color: primary,
      ),

    );
  }

  static get all {

    return {

      AppColors.BLUE :  _createTheme( Colors.blue, Colors.red ),
      AppColors.INDIGO :  _createTheme( Colors.indigo, Colors.red ),
      AppColors.CYAN :  _createTheme( Colors.cyan, Colors.red ),
      AppColors.TEAL :  _createTheme( Colors.teal, Colors.red ),

      AppColors.BROWN : _createTheme( Colors.brown, Colors.red ),
      AppColors.PURPLE :  _createTheme( Colors.purple, Colors.red ),
      AppColors.DEEP_PURPLE : _createTheme( Colors.deepPurple, Colors.red ),
      AppColors.AMBER :  _createTheme( Colors.amber, Colors.red ),

      AppColors.RED :  _createTheme( Colors.red, Colors.pink ),
      AppColors.PINK :  _createTheme( Colors.pink, Colors.red ),
      AppColors.GREY :  _createTheme( Colors.grey, Colors.red ),
      AppColors.BLUE_GREY :  _createTheme( Colors.blueGrey, Colors.red ),
      AppColors.BLACK :  ThemeData.dark().copyWith( accentColor: Colors.white ),

    };
  }

}