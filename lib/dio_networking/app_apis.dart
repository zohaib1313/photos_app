enum APIType {
  loginUser,
  registerUser,
  getReminders,
  createReminder,
  updateReminder,
  getNotes,
  createNotes,
  updateNotes,
  getMyData,
  getSharedData,
  getReceivedData,
  postMyData,
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
  static const getPrivateData = '/users/my-data/';
  static const getSharedData = '/users/shared-data/';
  static const getReceivedData = getPrivateData;
}
