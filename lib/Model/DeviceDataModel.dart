class Device {
  String key;
  String deviceName;
  String osVersion;
  String status;

  Device(this.deviceName, this.osVersion, this.status);

  Device.fromSnapshot(key, value)
      : key = key,
        deviceName = value["deviceName"],
        osVersion = value["osVersion"],
        status = value["status"];

  toJson() {
    return {
      "deviceName": deviceName,
      "osVersion": osVersion,
      "status": status,
    };
  }
}
