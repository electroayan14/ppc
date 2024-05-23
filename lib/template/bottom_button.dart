import "package:flutter/material.dart";

class BottomButton extends StatelessWidget {
  const BottomButton(
      {required this.label,
      this.isLoading = false,
      required this.onPressed,
      super.key});
  final String label;

  final void Function() onPressed;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: (isLoading == false)
              ? const MaterialStatePropertyAll(
                  Color.fromRGBO(224, 171, 67, 1),
                )
              : const MaterialStatePropertyAll(
                  Color.fromRGBO(116, 104, 82, 1),
                ),
          minimumSize: const MaterialStatePropertyAll(
            Size.fromHeight(55),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              label,
            ),
            (isLoading == false)
                ? const SizedBox()
                : const Center(
                    child: CircularProgressIndicator(),
                  )
          ],
        ),
      ),
    );
  }
}
