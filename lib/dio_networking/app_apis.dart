enum APIType {
  loginUser,
  registerUser,
  checkUniqueMail,
  updateUserProfile,

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
  deleteContent,

  ///shared folder
  getSharedReceivedData,
  postShareData,

  ///friends
  getAllFriends,
  sendFriendRequest,
  deleteFriendRequest,
  updateFriendRequestStatus,

  ///users
  searchUniqueUser,

  ///groups
  getAllGroups,
  addNewGroup,
  deleteGroup,
  updateGroup,
  shareDataInGroup,
  addMemberInGroup,
  removeMemberFromGroup,
  searchUserForGroup,

  ///push notification
  saveDeviceToken,
  sendNotification,
  getDeviceToken,
  updateDeviceToken,
  getNotifications,
  deleteNotification,
}

class ApiConstants {
  static var imageNetworkPlaceHolder =
      'https://rsjlawang.com/assets/images/lightbox/image-3.jpg';
  static const googleApiKey = 'AIzaSyC0-5OqwY75sPwoncSujsbkJD6wDU7BvOw';
  static const baseUrl = "https://memory-app34.herokuapp.com/";
  static const baseUrlNoSlash = "https://memory-app34.herokuapp.com";
  static const loginUser = '/users/login';
  static const users = 'users/user/';
  static const reminder = '/users/reminder/';
  static const notes = '/users/notes/';
  static const myData = '/users/my-data/';
  static const sharedData = '/users/shared-data/';
  static const checkUniqueMail = '/users/unique-email';
  static const friends = '/users/add-friend/';
  static const uniqueUser = '/users/unique-username';
  static const groups = '/users/group/';
  static const groupContent = '/users/group-content/';
  static const groupMember = '/users/group-member/';
  static const checkMembers = '/users/check-members/';
  static const devices = '/users/devices/';
  static const notifications = '/users/notifications/';

  static var pushServerKey = '';
}
