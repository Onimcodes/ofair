import 'package:flutter/material.dart';

class CallPage extends StatelessWidget {
  final String displayName;
  final String? avatarUrl;
  final bool isVideoCall;

  const CallPage({
    Key? key,
    this.displayName = 'Unknown',
    this.avatarUrl,
    this.isVideoCall = false,
  }) : super(key: key);

  Widget _buildControl({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color ?? Colors.grey.shade200,
          shape: const CircleBorder(),
          child: IconButton(
            icon: Icon(icon),
            color: Colors.black87,
            onPressed: onPressed,
            tooltip: label,
            iconSize: 26,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(displayName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Avatar / Video preview
              Center(
                child: avatarUrl != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(avatarUrl!),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 48, color: Colors.white),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              // Call status + duration
              Text(
                isVideoCall ? 'Video calling' : 'Voice calling',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Static placeholder for duration; replace with timer in a stateful implementation
              const Text(
                '00:00',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildControl(
                      icon: Icons.mic_off,
                      label: 'Mute',
                      onPressed: () {},
                    ),
                    _buildControl(
                      icon: isVideoCall ? Icons.videocam_off : Icons.videocam,
                      label: isVideoCall ? 'Video' : 'Camera',
                      onPressed: () {},
                    ),
                    // Hang up button (prominent)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Material(
                          color: Colors.redAccent,
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: const Icon(Icons.call_end),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            iconSize: 28,
                            tooltip: 'End call',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('End', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                    _buildControl(
                      icon: Icons.volume_up,
                      label: 'Speaker',
                      onPressed: () {},
                    ),
                    _buildControl(
                      icon: Icons.person_add,
                      label: 'Add',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}