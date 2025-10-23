import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  final List<String> _imageUrls = [
    'https://fastly.picsum.photos/id/1054/200/200.jpg?hmac=7qtHUdgOykmXnYkcUEqnGm7Xt76LA9cE0uag_o',
    'https://fastly.picsum.photos/id/1082/200/200.jpg?hmac=Tf8hIIQ9ThNP5_OQwQUoXm2zJySJ2pdFx8DjdhtC_g',
    'https://fastly.picsum.photos/id/937/200/200.jpg?hmac=8ePb28CQ2kaNQ6ytO6YTCO2fbnTxRGAM0dobGfdo_Q',
    'https://fastly.picsum.photos/id/842/200/200.jpg?hmac=RW9ifgAYLkwoincWsX_zrZHyOwnEgAvoZTPdcRGKM',
    'https://fastly.picsum.photos/id/1009/200/200.jpg?hmac=2Di0SFaY11fjz1L4jjZjmdlGf_ZjaJw89cntiJGdlGf',
  ];

  int _currentImageIndex = 0;

  void _changeImage() {
    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % _imageUrls.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFFF00E676),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: _imageUrls[_currentImageIndex],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(color: Colors.white),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person, size: 60, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF00E676), Color(0xFFF00C853)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: _changeImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Выйти из аккаунта',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
