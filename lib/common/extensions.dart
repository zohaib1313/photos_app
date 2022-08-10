import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RxNullable<T> {
  Rx<T> setNull() => (null as T).obs;
}
