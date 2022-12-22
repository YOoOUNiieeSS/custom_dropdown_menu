import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  final String text;
  const CustomDropDown({required this.text, super.key});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool isDropDownOpened = false;
  double? height, width, xPosition, yPosition;
  late OverlayEntry floatinDropdown;
  late GlobalKey actionKey;
  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.text);
    super.initState();
  }

  void findDropDownData() {
    RenderBox? renderBox =
        actionKey.currentContext!.findRenderObject() as RenderBox;
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset position = renderBox.localToGlobal(Offset.zero);
    xPosition = position.dx;
    yPosition = position.dy;
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition! + height!,
        height: 4 * height! + 40,
        child: DropDown(
          itemHeight: height!,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: () => setState(() {
        if (isDropDownOpened) {
          floatinDropdown.remove();
        } else {
          findDropDownData();
          floatinDropdown = _createFloatingDropdown();
          Overlay.of(context)!.insert(floatinDropdown);
        }
        isDropDownOpened = !isDropDownOpened;
      }),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(
              widget.text.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  const DropDown({required this.itemHeight, super.key});
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: const Alignment(-0.85, 0),
          child: ClipPath(
            clipper: ArrowClipper(),
            child: Container(
              height: 20,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.red.shade600,
              ),
            ),
          ),
        ),
        Material(
          elevation: 20,
          shape: ArrowShape(),
          child: Container(
            height: 4 * itemHeight,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Column(children: [
              DropDownItem.first(
                iconDate: Icons.add_circle_outline,
                isSelected: false,
                text: "Add New",
              ),
              const DropDownItem(
                iconDate: Icons.person_outline,
                isSelected: false,
                text: "view profile",
              ),
              const DropDownItem(
                iconDate: Icons.settings,
                isSelected: true,
                text: "Settings",
              ),
              DropDownItem.last(
                iconDate: Icons.exit_to_app,
                isSelected: false,
                text: "logout",
              ),
            ]),
          ),
        )
      ],
    );
  }
}

class DropDownItem extends StatelessWidget {
  final bool isSelected, isFirst, isLast;
  final String text;
  final IconData iconDate;
  const DropDownItem(
      {required this.iconDate,
      this.isSelected = false,
      required this.text,
      this.isFirst = false,
      this.isLast = false,
      super.key});

  factory DropDownItem.first({text, required IconData iconDate, isSelected}) =>
      DropDownItem(
        iconDate: iconDate,
        text: text,
        isFirst: true,
        isSelected: isSelected,
      );
  factory DropDownItem.last({text, required IconData iconDate, isSelected}) =>
      DropDownItem(
        iconDate: iconDate,
        text: text,
        isLast: true,
        isSelected: isSelected,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.red.shade900 : Colors.red.shade600,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(isFirst ? 8 : 0),
            bottom: Radius.circular(isLast ? 8 : 0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Icon(iconDate),
        ],
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class ArrowShape extends ShapeBorder {
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => throw UnimplementedError();

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return getClip(rect.size);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    throw UnimplementedError();
  }

  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    return path;
  }
}
