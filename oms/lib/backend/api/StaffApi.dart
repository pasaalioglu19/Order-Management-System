import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oms/backend/api/WarehouseApi.dart';
import 'package:oms/backend/api/connections/connections.dart';
import 'package:oms/backend/errors/UpdateErrrors.dart';
import 'package:oms/backend/models/Staff.dart';
import 'package:oms/backend/models/Warehouse.dart';

class StaffAPI {
  static CollectionReference connection = staffConnection;

  StaffAPI();

// Future<Staff>
  static Future<Staff> getOne(String id) async {
    var snapshot = await connection.doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data["id"] = id;
    Staff staff = Staff.fromMap(data);
    return staff;
  }

  static Future<List<Staff>> getSome(int threshold, int limit) async {
    var snapshots = await connection.limit(limit).get();

    List<Staff> staffs = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Staff staff = Staff.fromMap(data);
      staffs.add(staff);
    }

    return staffs;
  }

  static Future<List<Staff>> getAll() async {
    var snapshots = await connection.get();

    List<Staff> staffs = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Staff staff = Staff.fromMap(data);
      staffs.add(staff);
    }

    return staffs;
  }

  static Future<Map<String, dynamic>> deleteOne(id) async {
    try {
      Staff staff = await getOne(id);
      await deleteStaffUsingSecondaryApp(staff.email, staff.password);

      await connection.doc(id).delete();

      Map<String, dynamic> result = {
        "result": true,
        "info": "Staff successfully deleted!"
      };
      return result;
    } catch (e) {
      if (e is FirebaseException) {
        Map<String, dynamic> result = {
          "result": false,
          "info": "Exception from Firebase",
          "error": e
        };
        return result;
      }

      Map<String, dynamic> result = {
        "result": false,
        "info": "Unexpected Behaviour!",
        "error": e
      };
      return result;
    }
  }

  static Future<Map<String, dynamic>> insertWithMap(
      Map<String, dynamic> map) async {
    try {
      map["id"] = await addStaffUsingSecondaryApp(
          {'email': map['email'], 'password': map['password']});

      // This is for controlling might be changed
      Staff c = Staff.fromMap(map);
      map = c.to_Map();
      var doc = connection.doc(map["id"]);
      map.remove("id");
      await doc.set(map);

      Map<String, dynamic> result = {
        "result": true,
        "info": "Staff Succesfully Inserted"
      };
      return result;
    } catch (e) {
      if (e is FirebaseException) {
        Map<String, dynamic> result = {
          "result": false,
          "info": "Permission denied. Potantially email already used!",
          "error": e
        };
        return result;
      }

      Map<String, dynamic> result = {
        "result": false,
        "info": "Unexpected Behaviour! Control map keys!",
        "error": e
      };
      return result;
    }
  }

  static Future<Map<String, dynamic>> insertStaff(Staff staff) async {
    try {
      var map = staff.to_Map();
      map["id"] = await addStaffUsingSecondaryApp(
          {'email': map['email'], 'password': map['password']});
      var doc = connection.doc(map["id"]);
      map.remove("id");
      await doc.set(map);

      Map<String, dynamic> result = {
        "result": true,
        "info": "Staff Succesfully Inserted"
      };
      return result;
    } catch (e) {
      if (e is FirebaseException) {
        Map<String, dynamic> result = {
          "result": false,
          "info": "Permission denied. Potantially email already used!",
          "error": e
        };
        return result;
      }

      Map<String, dynamic> result = {
        "result": false,
        "info": "Unexpected Behaviour! Control map keys!",
        "error": e
      };
      return result;
    }
  }

  //TODO: This might be changed. There is a class named Stream search it
  static Future<Map<String, dynamic>> updateOne(
      id, Map<String, dynamic> changes) async {
    Map<String, dynamic> result = {};
    if (changes.isEmpty) {
      result = {
        "result": false,
        "info": "Update object cannot be empty!",
        "error": UpdateEmptyInputError()
      };
      return result;
    }

    Staff staff = await getOne(id);
    await updateStaffUsingSecondaryApp(
        staff.email, staff.password, changes['email'], changes['password']);

    await connection
        .doc(id)
        .update(changes)
        .then((value) =>
            {result["result"] = true, result["info"] = "Succesfully Updated"})
        .catchError((e) => {
              result["result"] = false,
              result["info"] = "Error while updating",
              result["error"] = e.toString()
            });
    return result;
  }

  static Future<Map<String, dynamic>> updateWarehouse(String id, String warehouse_id) async {
    Staff s = await StaffAPI.getOne(id);
    Warehouse old_warehouse = await WarehouseAPI.getOne(s.id!); 
    old_warehouse.removeStaff(id);
    Warehouse wh = await WarehouseAPI.getOne(warehouse_id);
    wh.addStaff(id);

    await WarehouseAPI.updateOne(warehouse_id, {"staff_ids": wh.staff_ids});
    await WarehouseAPI.updateOne(old_warehouse.id!, {"staff_ids": old_warehouse.staff_ids});

    return await updateOne(id, {"warehouse_id": warehouse_id});
  }

  static Future<Map<String, dynamic>> updateName(String id, String name) async {
    return await updateOne(id, {"name": name});
  }

  static Future<Map<String, dynamic>> updateSurName(
      String id, String surname) async {
    return await updateOne(id, {"surname": surname});
  }

  static Future<Map<String, dynamic>> updatePhone(
      String id, String phone) async {
    return await updateOne(id, {"phone": phone});
  }

  static Future<Map<String, dynamic>> updateEmail(
      String id, String email) async {
    return await updateOne(id, {"email": email});
  }

  static Future<Map<String, dynamic>> updatePassword(
      String id, String password) async {
    return await updateOne(id, {"password": password});
  }

  static Future<Map<String, dynamic>> updateState(
      String id, String state) async {
    return await updateOne(id, {"state": state});
  }

  static Future<Map<String, dynamic>> updateJob(String id, String job) async {
    return await updateOne(id, {"job": job});
  }
}

Future<void> deleteStaffUsingSecondaryApp(email, password) async {
  FirebaseAuth secondaryAuth =
      FirebaseAuth.instanceFor(app: Firebase.app('SecondaryApp'));

  await secondaryAuth.signInWithEmailAndPassword(
      email: email, password: password);

  await secondaryAuth.currentUser!.delete();
}

Future<String> addStaffUsingSecondaryApp(Map<String, dynamic> formData) async {
  String _userId = "";

  try {
    FirebaseAuth secondaryAuth =
        FirebaseAuth.instanceFor(app: Firebase.app('SecondaryApp'));

    UserCredential userCredential =
        await secondaryAuth.createUserWithEmailAndPassword(
      email: formData['email'],
      password: formData['password'],
    );

    _userId = userCredential.user!.uid;

    await secondaryAuth.signOut();
  } catch (e) {
    return e.toString();
  }
  return _userId;
}

Future<void> updateStaffUsingSecondaryApp(
    oldEmail, oldPassword, newEmail, newPassword) async {
  FirebaseAuth secondaryAuth =
      FirebaseAuth.instanceFor(app: Firebase.app('SecondaryApp'));

  if (newEmail != null && newPassword != null) {
    await secondaryAuth.signInWithEmailAndPassword(
        email: oldEmail, password: oldPassword);
    final user = await secondaryAuth.currentUser;
    await user?.updateEmail(newEmail);
    await secondaryAuth.signOut();
    await secondaryAuth.signInWithEmailAndPassword(
        email: newEmail, password: oldPassword);
    final user2 = await secondaryAuth.currentUser;
    await user2?.updatePassword(newPassword);
  } else if (newEmail != null && newPassword == null) {
    await secondaryAuth.signInWithEmailAndPassword(
        email: oldEmail, password: oldPassword);
    final user = await secondaryAuth.currentUser;
    await user?.updateEmail(newEmail);
  } else if (newEmail == null && newPassword != null) {
    await secondaryAuth.signInWithEmailAndPassword(
        email: oldEmail, password: oldPassword);
    final user = await secondaryAuth.currentUser;
    await user?.updatePassword(newPassword);
  } else {
    return;
  }

  await secondaryAuth.signOut();
}
