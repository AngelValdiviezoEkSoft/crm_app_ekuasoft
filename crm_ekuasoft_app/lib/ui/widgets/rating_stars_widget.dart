import 'package:flutter/material.dart';

class RatingStarsWidget extends StatefulWidget {
  final int initialRating;
  final double size;
  final ValueChanged<int> onRatingChanged;

  const RatingStarsWidget({
    super.key,
    this.initialRating = 0,
    this.size = 10,
    required this.onRatingChanged,
  });

  @override
  State<RatingStarsWidget> createState() => _RatingStarsWidgetState();
}

class _RatingStarsWidgetState extends State<RatingStarsWidget> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _rating = index + 1;
              });
              widget.onRatingChanged(_rating);
            },
            child: Icon(
              Icons.star,
              color: index < _rating ? Colors.amber : Colors.grey,
              size: widget.size//28,
            ),
          ),
        );
      }),
    );
  }
}
