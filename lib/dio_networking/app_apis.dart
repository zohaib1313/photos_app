enum APIType {
  loginUser,
  registerUser,
  getReminders,
  createReminder,
  updateReminder,
  deleteReminder,
  getNotes,
  createNotes,
  updateNotes,
  postMyData,
  getMyData,
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
}
