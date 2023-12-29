import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/theme_notifier.dart';

class MessageBubble extends StatelessWidget {
  final String userName;
  final String userImage;
  final String message;
  final bool isMe;

  const MessageBubble({
    Key? key,
    required this.userName,
    required this.userImage,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  ImageProvider<Object> _getUserImage() {
    // Placeholder image for empty or invalid URLs
    const placeholderImage = AssetImage(
        'assets/images/imperial_logo.png'); // Replace with your asset
    // Check if the URL is valid
    if (userImage.isNotEmpty) {
      return NetworkImage(userImage);
    }
    return placeholderImage;
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeNotifier>(context).getTheme();
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentTheme.textTheme.bodyText1
                      ?.color, // Use text color from the theme
                ),
              ),
              Material(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: isMe ? Radius.circular(14) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(14),
                ),
                elevation: 5,
                color: isMe
                    ? currentTheme.cardColor
                    : currentTheme
                        .primaryColor, // Use card and primary color from the theme
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
      ],
    );
  }
}
