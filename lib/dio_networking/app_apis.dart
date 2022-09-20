enum APIType {
  loginUser,
  registerUser,
  checkUniqueMail,

  ///reminders
  getReminders,
  createReminder,
  updateReminder,
  deleteReminder,

  ///notes
  getNotes,
  createNotes,
  updateNotes,
  deleteNotes,

  ///private folder
  postMyData,
  getMyData,

  ///shared folder
  getSharedReceivedData
}

class ApiConstants {
  static var imageNetworkPlaceHolder =
      'https://rsjlawang.com/assets/images/lightbox/image-3.jpg';
  static const googleApiKey = 'AIzaSyC0-5OqwY75sPwoncSujsbkJD6wDU7BvOw';
  static const baseUrl = "https://memory-app34.herokuapp.com/";
  static const loginUser = '/users/login';
  static const registerUser = 'users/user/';
  static const reminder = '/users/reminder/';
  static const notes = '/users/notes/';
  static const myData = '/users/my-data/';
  static const sharedData = '/users/shared-data/';
  static const checkUniqueMail = '/users/unique-email';
}
