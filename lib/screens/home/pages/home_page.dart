import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ofair/common/dependency_injection.dart';
import 'package:ofair/common/widgets/ofar_toast.dart';
import 'package:ofair/domain/repository/users_repository.dart';
import 'package:ofair/presentation/login_bloc/login_bloc.dart';
import 'package:ofair/presentation/ride_request_bloc/ride_requests_bloc.dart';
import 'package:ofair/presentation/ride_request_bloc/ride_requests_event.dart';
import 'package:ofair/presentation/ride_request_bloc/ride_requests_state.dart';
import 'package:ofair/screens/requests/pages/ride_details_page.dart';
import 'dart:math';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  Map<String, dynamic>? get _userData {
    try {
      final usersRepository = getit<UsersRepository>();
      return usersRepository.getCachedUserData();
    } catch (e) {
      debugPrint('Error loading user data: $e');
      return null;
    }
  }

  String get _userName {
    if (_userData == null) return 'Guest';
    return _userData!['name'] ?? 
           _userData!['username'] ??
           'There';
  }

  String get _userId {
    if (_userData == null) return 'Guest';
    return _userData!['userId'] ?? 
           'User';
  }

  String? get _profileImage => _userData?['profilePic'];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => getit<LoginBloc>()),
        BlocProvider<RideRequestsBloc>(
          create: (context) => getit<RideRequestsBloc>()
            ..add(GetRideRequestEvent(userId: _userId)),
        )
      ],
      child: _HomePageContent(
        userName: _userName,
        userId: _userId,
        profileImage: _profileImage,
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  final String userName;
  final String userId;
  final String? profileImage;

  const _HomePageContent({
    required this.userName,
    required this.userId,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              backgroundImage: profileImage != null ? NetworkImage(profileImage!) : null,
              child: profileImage == null
                  ? Image.asset('assets/ofairdark.png', width: 32, height: 32)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${_greeting()}, $userName',
                style: Theme.of(context).appBarTheme.titleTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.primary),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                'Share a ride now...',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  // Get the bloc before showing the bottom sheet
                  final rideRequestsBloc = context.read<RideRequestsBloc>();
                  
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (sheetContext) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                        left: 16,
                        right: 16,
                        top: 24,
                      ),
                      child: BlocProvider.value(
                        value: rideRequestsBloc,
                        child: _AddRideRequestForm(
                          userName: userName,
                          userId: userId,
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline, size: 24),
                label: const Text(
                  "Add New Ride Request",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  'Recent Trips',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: BlocBuilder<RideRequestsBloc, RideRequestsState>(
                    builder: (context, state) {
                      if (state.status == RideRequestsStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.status == RideRequestsStatus.success) {
                        if (state.rideRequests == null || state.rideRequests!.isEmpty) {
                          return Center(
                            child: Text(
                              'No rides yet. Share your first ride!',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<RideRequestsBloc>().add(
                              GetRideRequestEvent(userId: userId),
                            );
                          },
                          child: ListView.builder(
                            itemCount: state.rideRequests!.length,
                            itemBuilder: (context, index) {
                              final ride = state.rideRequests![index];
                              return Card(
                                color: Theme.of(context).colorScheme.background,
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                child: ListTile(
                                  leading: ride.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            ride.imageUrl!,
                                            width: 56,
                                            height: 56,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => 
                                                const Icon(Icons.image_not_supported),
                                          ),
                                        )
                                      : Icon(
                                          Icons.directions_car,
                                          size: 40,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  title: Text(
                                    ride.rideTag ?? 'No Tag',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    ride.createdAt != null
                                        ? DateTime.tryParse(ride.createdAt.toString()) != null
                                            ? 'Created: ${DateTime.parse(ride.createdAt.toString()).toLocal()}'
                                            : 'Created: ${ride.createdAt}'
                                        : 'No date',
                                  ),
                                  onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RideDetailsPage(ride: ride),
                                  ),
                                );
                            },
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Center(
                        child:  CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_outlined),
            label: 'Call',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation logic here
        },
      ),
    );
  }
}

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good morning';
  } else if (hour < 17) {
    return 'Good afternoon';
  } else {
    return 'Good evening';
  }
}

String _randomizedRideTag(String username) {
  final adjectives = [
    'Sunny', 'Swift', 'Happy', 'Brave', 'Chill', 'Quick', 'Cozy', 'Urban', 'Easy', 'Fresh'
  ];
  final nouns = [
    'Drive', 'Trip', 'Journey', 'Ride', 'Route', 'Cruise', 'Hop', 'Dash', 'Tour', 'Voyage'
  ];
  final rand = Random();
  final adj = adjectives[rand.nextInt(adjectives.length)];
  final noun = nouns[rand.nextInt(nouns.length)];
  final userPart = (username.isNotEmpty ? username : 'user').substring(0, min(4, username.length));
  return '$adj$noun-$userPart';
}

class _AddRideRequestForm extends StatefulWidget {
  final String userName;
  final String userId;

  const _AddRideRequestForm({
    Key? key,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  @override
  State<_AddRideRequestForm> createState() => _AddRideRequestFormState();
}

class _AddRideRequestFormState extends State<_AddRideRequestForm> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  final _picker = ImagePicker();
  String? _rideName;
  late TextEditingController _rideNameController;

  @override
  void initState() {
    super.initState();
    final randomTag = _randomizedRideTag(widget.userName);
    _rideNameController = TextEditingController(text: randomTag);
    _rideName = randomTag;
  }

  @override
  void dispose() {
    _rideNameController.dispose();
    super.dispose();
  }
 
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
      });
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_pickedImage == null) {
      showSimpleNotification(
        const OfairToast(
          message: 'Please select an image',
          success: false,
        ),
        background: Colors.transparent,
        position: NotificationPosition.top,
        autoDismiss: true,
        slideDismiss: true,
      );
      return;
    }

    _formKey.currentState?.save();
    
    context.read<RideRequestsBloc>().add(
      CreateRideRequestEvent(
        rideTag: _rideName ?? _rideNameController.text,
        userId: widget.userId,
        rideInfoImage: File(_pickedImage!.path),
      ),
    );
    
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RideRequestsBloc, RideRequestsState>(
      listener: (context, state) {
        if (state.status == RideRequestsStatus.created) {
          showSimpleNotification(
            OfairToast(
              message: 'Ride request "${_rideName ?? _rideNameController.text}" submitted successfully!',
              success: true,
            ),
            background: Colors.transparent,
            position: NotificationPosition.top,
            autoDismiss: true,
            slideDismiss: true,
          );
          context.read<RideRequestsBloc>().add(
            GetRideRequestEvent(userId: widget.userId),
          );
        } else if (state.status == RideRequestsStatus.error) {
          showSimpleNotification(
            OfairToast(
              message: state.errorMessage ?? 'Failed to submit ride request',
              success: false,
            ),
            background: Colors.transparent,
            position: NotificationPosition.top,
            autoDismiss: true,
            slideDismiss: true,
          );
        }
      },
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New Ride Request',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rideNameController,
                decoration: InputDecoration(
                  labelText: 'Ride Name',
                  hintText: 'Auto-generated ride name',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      final newTag = _randomizedRideTag(widget.userName);
                      setState(() {
                        _rideNameController.text = newTag;
                        _rideName = newTag;
                      });
                    },
                    tooltip: 'Generate new name',
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a name' : null,
                onChanged: (val) => _rideName = val,
                onSaved: (val) => _rideName = val,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: _pickedImage == null
                    ? Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Center(
                          child: Icon(Icons.camera_alt, size: 40),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_pickedImage!.path),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              if (_pickedImage != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Image selected',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              BlocBuilder<RideRequestsBloc, RideRequestsState>(
                builder: (context, state) {
                  final isCreating = state.status == RideRequestsStatus.creating;
                  
                  return ElevatedButton.icon(
                    onPressed: isCreating ? null : _submit,
                    icon: isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(isCreating ? 'Submitting...' : 'Submit'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size.fromHeight(48),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}