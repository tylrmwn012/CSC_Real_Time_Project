
class Message { // initialize class Message
  String sender = "Tyler" ; // set string sender as the string Tyler
  String content = "Hello World" ; // set string content as string Hello World
  DateTime timestamp = DateTime.now() ; // set DateTime timestamp as current time with function now()

  String display() { // initialize function display() with String return
    return "From: $sender, Message: $content, Sent at: $timestamp"; // return string
  } // close function
} // close class

void main() { // open void main() to display class and function
  var x = Message() ; // set var x equal to Message()
  print(x.display()); // print display() function from Message class
} // close void main() function
