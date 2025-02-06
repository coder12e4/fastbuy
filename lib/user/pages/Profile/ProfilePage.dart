import 'package:fastbuy/core/constants.dart';
import 'package:fastbuy/user/userCubit/profile/profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../userCubit/loginCubit/login_user_cubit.dart';

class Profilepage extends StatefulWidget {
  final String userId;
  const Profilepage({super.key, required this.userId});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  late ProfileCubit profileCubit;
  late LoginUserCubit auth_cubit;
  final usernameTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();
  final confirmpasswordTxtController = TextEditingController();
  final homeNameTxtController = TextEditingController();
  final homeNoTxtController = TextEditingController();
  final locationTxtController = TextEditingController();
  final districtTxtController = TextEditingController();
  final pinTxtController = TextEditingController();
  final whatsApp1 = TextEditingController();
  final whatsApp2 = TextEditingController();
  final mobileNumber = TextEditingController();
  final email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscured = false;
  final textFieldFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    auth_cubit = LoginUserCubit();
    profileCubit = ProfileCubit();
    profileCubit.getProfile(widget.userId);
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  Widget ProfileElements(String? itemName, String? itemValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            itemName!,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
        Text(
          itemValue!,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }

  String? lat = "";
  String? long = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FbColors.primaryColor,
        title: Text("Profile"),
      ),
      body: Container(
        child: BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(),
          child: BlocListener<ProfileCubit, ProfileState>(
            bloc: profileCubit,
            listener: (context, state) {
              if (state is ProfileInitial) {
              } else if (state is ProfileLoading) {
              } else if (state is ProfileFail) {
              } else if (state is ProfileSuccess) {
                homeNameTxtController.text = state.userModel.houseName!;
                homeNoTxtController.text = state.userModel.homeNo!;
                locationTxtController.text = state.userModel.location!;
                districtTxtController.text = state.userModel.district!;
                pinTxtController.text = state.userModel.pin!;
                whatsApp1.text = state.userModel.whatsAppNo!;
                whatsApp2.text = state.userModel.contactNo2!;
              } else if (state is EditProfileInitial) {
              } else if (state is EditProfileLoading) {
              } else if (state is EditProfileSuccess) {
              } else if (state is EditProfileFail) {}
            },
            child: BlocBuilder<ProfileCubit, ProfileState>(
              bloc: profileCubit,
              builder: (context, state) {
                if (state is ProfileInitial) {
                  return Container();
                } else if (state is ProfileLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ProfileFail) {
                  return Center(
                    child: ErrorWidget('Something went wrong'),
                  );
                } else if (state is ProfileSuccess) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfileElements("User name", state.userModel.userName),
                        const SizedBox(
                          height: 14,
                        ),
                        ProfileElements("Street", state.userModel.street),
                        const SizedBox(
                          height: 8,
                        ),
                        ProfileElements("Place", state.userModel.place),
                        const SizedBox(
                          height: 8,
                        ),
                        ProfileElements("Location", state.userModel.location),
                        const SizedBox(
                          height: 8,
                        ),
                        ProfileElements("Locality", state.userModel.locality),
                        const SizedBox(
                          height: 8,
                        ),
                        ProfileElements("District", state.userModel.district),
                        const SizedBox(
                          height: 8,
                        ),
                        ProfileElements(
                            "WhatsApp No", state.userModel.whatsAppNo),
                        const SizedBox(
                          height: 8,
                        ),
                        ProfileElements(
                            "WhatsApp No 2", state.userModel.contactNo2),
                        const SizedBox(
                          height: 8,
                        ),
                        ProfileElements(
                            "Seller name", state.userModel.shopmo!.name),
                        const SizedBox(
                          height: 8,
                        ),
                        ProfileElements(
                            "Seller contact", state.userModel.shopmo!.contact),
                        const SizedBox(
                          height: 8,
                        ),
                        ProfileElements("Seller Adress",
                            state.userModel.shopmo!.shopAddress),
                        Expanded(child: SizedBox()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                profileCubit.editProfileInitial();
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: FbColors.primaryColor,
                                    borderRadius: BorderRadius.circular(80)),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  );
                } else if (state is EditProfileInitial) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Username
                          const SizedBox(
                            height: 8,
                          ),
                          // Password
                          TextFormField(
                            obscureText: _obscured,
                            controller: passwordTxtController,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: InputDecoration(
                              labelText: "Enter your password",
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: GestureDetector(
                                  onTap: _toggleObscured,
                                  child: Icon(
                                    _obscured
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // Confirm Password
                          TextFormField(
                            obscureText: _obscured,
                            controller: confirmpasswordTxtController,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: InputDecoration(
                              labelText: "Confirm password",
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: GestureDetector(
                                  onTap: _toggleObscured,
                                  child: Icon(
                                    _obscured
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordTxtController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // Home Name
                          TextFormField(
                            controller: homeNameTxtController,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: const InputDecoration(
                              labelText: "House name",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your house name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: homeNoTxtController,
                                  maxLines: 1,
                                  maxLength: 100,
                                  decoration: const InputDecoration(
                                    labelText: "House Number",
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your house number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 18,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: locationTxtController,
                                  maxLines: 1,
                                  maxLength: 100,
                                  decoration: const InputDecoration(
                                    labelText: "House location",
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your house location';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const SizedBox(
                            width: 30,
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: whatsApp1,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: const InputDecoration(
                              labelText: "Contact number 1",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your contact number';
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Please enter a valid contact number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: whatsApp2,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: const InputDecoration(
                              labelText: "Contact number 2",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your contact number';
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Please enter a valid contact number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add your Exact delivery location",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 45,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                child: Text("latitude"),
                              ),
                              Container(
                                height: 45,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                child: Text("logitude"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Position? position = await profileCubit
                                      .getCurrentLocationDetails();
                                  lat = position!.longitude.toString();
                                  long = position.longitude.toString();
                                },
                                child: SizedBox(
                                  width: 100,
                                  height: 25,
                                  child: Center(child: Text("Add Location")),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Position? position = await profileCubit
                                      .getCurrentLocationDetails();
                                  if (position != null) {
                                    lat = position.latitude.toString();
                                    long = position.longitude.toString();

                                    String googleMapsUrl =
                                        "https://www.google.com/maps/search/?api=1&query=$lat,$long";
                                    if (await canLaunchUrl(
                                        Uri.parse(googleMapsUrl))) {
                                      await launchUrl(Uri.parse(googleMapsUrl));
                                    } else {
                                      throw 'Could not open the map.';
                                    }
                                  }
                                },
                                child: Text("Open Google Maps"),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (lat == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Please add location")));
                                } else {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    profileCubit.getProfile(widget.userId);
                                  }
                                }
                              },
                              child: Text(
                                "Update",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is EditProfileLoading) {
                  return Container();
                } else if (state is EditProfileSuccess) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          // Username
                          TextFormField(
                            controller: usernameTxtController,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: const InputDecoration(
                              labelText: "Enter your email",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // Password
                          TextFormField(
                            obscureText: _obscured,
                            controller: passwordTxtController,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: InputDecoration(
                              labelText: "Enter your password",
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: GestureDetector(
                                  onTap: _toggleObscured,
                                  child: Icon(
                                    _obscured
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // Confirm Password
                          TextFormField(
                            obscureText: _obscured,
                            controller: confirmpasswordTxtController,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: InputDecoration(
                              labelText: "Confirm password",
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: GestureDetector(
                                  onTap: _toggleObscured,
                                  child: Icon(
                                    _obscured
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordTxtController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // Home Name
                          TextFormField(
                            controller: homeNameTxtController,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: const InputDecoration(
                              labelText: "House name",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your house name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: homeNoTxtController,
                                  maxLines: 1,
                                  maxLength: 100,
                                  decoration: const InputDecoration(
                                    labelText: "House Number",
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your house number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 18,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: locationTxtController,
                                  maxLines: 1,
                                  maxLength: 100,
                                  decoration: const InputDecoration(
                                    labelText: "House location",
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your house location';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select your seller",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: whatsApp1,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: const InputDecoration(
                              labelText: "Contact number 1",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your contact number';
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Please enter a valid contact number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: whatsApp2,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: const InputDecoration(
                              labelText: "Contact number 2",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your contact number';
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Please enter a valid contact number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add your Exact delivery location",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 45,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                child: Text("latitude"),
                              ),
                              Container(
                                height: 45,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                child: Text("logitude"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  auth_cubit.getCurrentLocationDetails();
                                },
                                child: SizedBox(
                                  width: 100,
                                  height: 25,
                                  child: Center(child: Text("Add Location")),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (lat == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Please add location")));
                                } else {
                                  if (_formKey.currentState?.validate() ??
                                      false) {}
                                }
                              },
                              child: Text(
                                "Update",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is EditProfileFail) {
                  return Container();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
