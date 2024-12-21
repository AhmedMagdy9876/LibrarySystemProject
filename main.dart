import 'dart:io';

void main(List<String> args) {
  var library = Library();

  while (true) {
    var transactionType = enterSingleCharacter(
        "Enter transaction type (u for add user / b for add book / l for lend book / r for return book / i for info / q for quit)",
        "uUbBlLrRiIqQ");

    switch (transactionType) {
      case 'u':
      case 'U':
        print("Enter user ID:");
        String userId = stdin.readLineSync() ?? "";
        print("Enter user name:");
        String userName = stdin.readLineSync() ?? "";
        library.addUser(User(userId, userName));
        break;

      case 'b':
      case 'B':
        print("Enter book ID:");
        String bookId = stdin.readLineSync() ?? "";
        print("Enter book title:");
        String bookTitle = stdin.readLineSync() ?? "";
        library.addBook(Book(bookId, bookTitle));
        break;

      case 'l':
      case 'L':
        print("Enter user ID:");
        String userId = stdin.readLineSync() ?? "";
        print("Enter book ID:");
        String bookId = stdin.readLineSync() ?? "";
        library.borrowBook(userId, bookId);
        break;

      case 'r':
      case 'R':
        print("Enter user ID:");
        String userId = stdin.readLineSync() ?? "";
        print("Enter book ID:");
        String bookId = stdin.readLineSync() ?? "";
        library.returnBook(userId, bookId);
        break;

      case 'i':
      case 'I':
        library.displayLibraryInfo();
        break;

      case 'q':
      case 'Q':
        print("Exiting the system.");
        return;

      default:
        print("Invalid transaction type");
        break;
    }
  }
}

/// @brief Prompts the user to enter a single character from a set of valid characters.
String enterSingleCharacter(String prompt, String validCharacters) {
  while (true) {
    print(prompt);

    String response = stdin.readLineSync() ?? "";

    bool valid = response.length == 1 && validCharacters.contains(response);

    if (valid) {
      return response;
    }

    print("invalid input");
  }
}

/// @brief Prompts the user to enter a double value.
double enterDouble(String prompt) {
  while (true) {
    try {
      print(prompt);
      return double.parse(stdin.readLineSync() ?? "");
    } catch (e) {
      print("invalid input");
      continue;
    }
  }
}

class Book {
  String _id;
  String _title;
  bool _isBorrowed;

  Book(this._id, this._title) : this._isBorrowed = false;

  void borrow() {
    _isBorrowed = true;
  }

  void returnBook() {
    _isBorrowed = false;
  }

  bool get isBorrowed => _isBorrowed;

  void displayBookInfo() {
    print("*** Book Info ***");
    print("Book ID: ${_id}");
    print("Book Title: ${_title}");
    print("Book Status: ${_isBorrowed ? "Borrowed" : "Available"}");
    print("*****************");
  }
}

class User {
  String _id;
  String _name;
  List<Book> _borrowedBooks;

  User(this._id, this._name) : this._borrowedBooks = [];

  void borrowBook(Book book) {
    book.borrow();
    _borrowedBooks.add(book);
  }

  void returnBook(Book book) {
    if (_borrowedBooks.contains(book)) {
      book.returnBook();
      _borrowedBooks.remove(book);
      print("Book returned successfully");
    } else {
      print("Error: This book was not borrowed by the user");
    }
  }

  void displayUserInfo() {
    print("*** User Info ***");
    print("User ID: ${_id}");
    print("User Name: ${_name}");
    print("Borrowed Books:");

    for (var book in _borrowedBooks) {
      print("  - ${book._title}");
    }

    print("*****************");
  }
}

class Library {
  List<Book> _books;
  List<User> _users;

  Library() : _books = [], _users = [];

  void addBook(Book book) {
    if (findBookById(book._id) != null) {
      print("Error: Book with ID ${book._id} already exists");
      return;
    }
    _books.add(book);
    print("Book added successfully");
  }

  void addUser(User user) {
    if (findUserById(user._id) != null) {
      print("Error: User with ID ${user._id} already exists");
      return;
    }
    _users.add(user);
    print("User added successfully");
  }

  Book? findBookById(String id) {
    for (var book in _books) {
      if (book._id == id) {
        return book;
      }
    }
    return null;
  }

  User? findUserById(String id) {
    for (var user in _users) {
      if (user._id == id) {
        return user;
      }
    }
    return null;
  }

  void displayLibraryInfo() {
    print("*** Library Info ***");
    print("Books:");
    for (var book in _books) {
      book.displayBookInfo();
    }
    print("Users:");
    for (var user in _users) {
      user.displayUserInfo();
    }
    print("********************");
  }

  void borrowBook(String userId, String bookId) {
    var user = findUserById(userId);
    var book = findBookById(bookId);

    if (user == null) {
      print("User not found");
      return;
    }

    if (book == null) {
      print("Book not found");
      return;
    }

    if (book.isBorrowed) {
      print("Book is already borrowed");
      return;
    }

    user.borrowBook(book);
    print("Book borrowed successfully");
  }

  void returnBook(String userId, String bookId) {
    var user = findUserById(userId);
    var book = findBookById(bookId);

    if (user == null) {
      print("User not found");
      return;
    }

    if (book == null) {
      print("Book not found");
      return;
    }

    if (!book.isBorrowed) {
      print("Book is not borrowed");
      return;
    }

    user.returnBook(book);
  }
}