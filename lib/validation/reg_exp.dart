final RegExp emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp passOneUpperCase = RegExp(r'[A-Z]');
final RegExp passOneLowerCase = RegExp(r'[a-z]');
final RegExp passOneDigit = RegExp(r'[0-9]');
final RegExp passOneSpecialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>]');


// final RegExp passwordValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
/* RegExp passwordValid explanation
*  r'^
*     (?=.*[A-Z])       // should contain at least one upper case
*     (?=.*[a-z])       // should contain at least one lower case
*     (?=.*?[0-9])      // should contain at least one digit
*     (?=.*?[!@#\$&*~]) // should contain at least one special character
*     .{8,}             // must be at least 8 characters in length
*  $
*/
