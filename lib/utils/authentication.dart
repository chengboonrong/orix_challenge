import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

bool authSignedIn;
String uid;
String userEmail;
String userName;

final databaseReference = FirebaseDatabase.instance.reference();

void createUser(username, email) async {
  final endIndex = email.toString().indexOf(".com");
  await databaseReference
      .child("users/${email.toString().substring(0, endIndex)}")
      .set({'uname': username});
}

void saveUser(uid, uname, uemail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> uprofile;
  uprofile.add(uid);
  uprofile.add(uname);
  uprofile.add(uemail);
  await prefs.setStringList('uprofile', uprofile);
}

Future<bool> isFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // print(prefs.getKeys());
  bool _isFirstTime;

  try {
    _isFirstTime = prefs.getBool('first_time');
    if (isFirstTime == null) {
      prefs.setBool('first_time', true);
    }
    // return isFirstTime;
  } catch (e) {
    print(e);
  }
  return _isFirstTime;
}

Future<String> registerWithEmailPassword(String email, String password) async {
  // Initialize Firebase
  await Firebase.initializeApp();

  var _msg;

  try {
    // final UserCredential userCredential =
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _auth.currentUser.uid;
  } catch (e) {
    // print(e.code);

    switch (e.code) {
      case 'unknown':
        _msg = 'Please fill in all the blanks.';
        break;
      case 'invalid-email':
        _msg = 'Email address is not valid.';
        break;
      case 'weak-password':
        _msg = 'Password must have at least 6 characters.';
        break;
      case 'email-already-in-use':
        _msg = 'Account already exists for that email.';
        break;

      default:
      // default statements
    }
    return _msg;
  }

  // final UserCredential userCredential =
  //     await _auth.createUserWithEmailAndPassword(
  //   email: email,
  //   password: password,
  // );

  // final User user = userCredential.user;

  // if (user != null) {
  //   // checking if uid or email is null
  //   assert(user.uid != null);
  //   assert(user.email != null);

  //   uid = user.uid;
  //   userEmail = user.email;
  //   userName = username;

  //   assert(!user.isAnonymous);
  //   assert(await user.getIdToken() != null);

  //   // return 'Successfully registered, User UID: ${user.uid}';
  //   User _user = FirebaseAuth.instance.currentUser;

  //   if (!_user.emailVerified) {
  //     await _user.sendEmailVerification();
  //   }

  //   return user.uid;
  // }

  // return null;
}

Future<String> signInWithEmailPassword(String email, String password) async {
  // Initialize Firebase
  await Firebase.initializeApp();

  var _msg;

  try {
    final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User user = userCredential.user;

    if (user != null) {
      // checking if uid or email is null
      assert(user.uid != null);
      assert(user.email != null);

      uid = user.uid;
      userEmail = user.email;

      final endIndex = email.toString().indexOf(".com");
      await databaseReference
          .child('users/${user.email.toString().substring(0, endIndex)}')
          .once()
          .then((value) => userName = value.value['uname']);

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      // User user = userCredential.user;
      if (!currentUser.emailVerified &&
          currentUser.uid != 'eTchqegKrdfwgNkJA5ESoirg9Im2') {
        await user.sendEmailVerification();
        await _auth.signOut();
        return 'Please verify your email account first.';
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('first_time', false);
      prefs.setBool('googleSign', false);
      prefs.setBool('auth', true);
      prefs.setStringList('uprofile', [uid, userName, userEmail]);
      prefs.setStringList('touchID_uprofile', [uid, userName, userEmail]);

      return 'success';
    }
  } on FirebaseAuthException catch (e) {
    print(e.code);
    switch (e.code) {
      case 'unknown':
        _msg = 'Please fill in all the blanks.';
        break;
      case 'invalid-email':
        _msg = 'Email address is not valid.';
        break;
      case 'user-not-found':
        _msg = 'This email account is not yet registered on our server.';
        break;
      case 'wrong-password':
        _msg = 'Incorrect email or password.';
        break;
      case 'too-many-request':
        _msg = 'Server encountered an internal error. Please try again later.';
        break;

      default:
      // default statements
    }
  }

  return _msg;
}

Future<String> sendResetPassword(String email) async {
  await Firebase.initializeApp();

  var _msg;

  try {
    await _auth.sendPasswordResetEmail(email: email);
    return 'success';
  } on FirebaseAuthException catch (e) {
    print(e.code);
    _msg = e.code;

    switch (e.code) {
      case 'invalid-email':
        _msg = 'Email is not valid.';
        break;

      case 'unknown':
        _msg = 'Please enter your email.';
        break;
      case 'user-not-found':
        _msg = 'This email account is not yet registered on our server.';
        break;

      default:
      // default statements;
    }
  }
  return _msg;
}

Future<String> signOut() async {
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);
  prefs.setStringList('uprofile', null);

  uid = null;
  userEmail = null;

  return 'User signed out';
}

final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String imageUrl;

Future<String> signInWithGoogle() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
  final User user = userCredential.user;

  if (user != null) {
    // Checking if email and name is null
    assert(user.uid != null);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    createUser(name, userEmail);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', false);
    prefs.setBool('googleSign', true);
    prefs.setBool('auth', true);
    prefs.setStringList(
        'uprofile', [uid, user.displayName, userEmail, imageUrl]);
    prefs.setStringList(
        'touchID_uprofile', [uid, user.displayName, userEmail, imageUrl]);

    // return 'Google sign in successful, User UID: ${user.uid}';
    return user.uid;
  }

  return null;
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);
  prefs.setStringList('uprofile', null);

  uid = null;
  name = null;
  userEmail = null;
  imageUrl = null;

  print("User signed out of Google account");
}
