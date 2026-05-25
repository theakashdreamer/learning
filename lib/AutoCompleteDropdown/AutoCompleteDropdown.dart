import 'package:flutter/material.dart';

class AutoCompleteDropdown extends StatefulWidget {
  final List<String> items;
  final String? label;
  final String? initialValue;
  final Function(String)? onSelected;

  const AutoCompleteDropdown({
    super.key,
    required this.items,
    this.label,
    this.initialValue,
    this.onSelected,
  });

  @override
  State<AutoCompleteDropdown> createState() => _AutoCompleteDropdownState();
}

class _AutoCompleteDropdownState extends State<AutoCompleteDropdown> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late LayerLink _layerLink;
  OverlayEntry? _overlayEntry;
  List<String> _filteredItems = [];
  bool _hasClearedOnce = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _focusNode = FocusNode();
    _layerLink = LayerLink();
    _filteredItems = widget.items;

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        if (!_hasClearedOnce && _controller.text == widget.initialValue) {
          _controller.clear(); // ✅ Clear only once
          _hasClearedOnce = true;
        }
        _updateOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _updateOverlay() {
    _removeOverlay();

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;

    _filteredItems = _controller.text.isEmpty
        ? widget.items
        : widget.items.where((item) {
            return item.toLowerCase().contains(_controller.text.toLowerCase());
          }).toList();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 500,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      _controller.text = item;
                      widget.onSelected?.call(item);
                      _removeOverlay();
                      _focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: widget.label ?? "Select Item",
          border: const OutlineInputBorder(),
          suffixIcon: GestureDetector(
            onTap: () {
              if (_focusNode.hasFocus) {
                _removeOverlay();
                _focusNode.unfocus();
              } else {
                FocusScope.of(context).requestFocus(_focusNode);
              }
            },
            child: const Icon(Icons.arrow_drop_down),
          ),
        ),
        onChanged: (value) {
          _updateOverlay();
        },
      ),
    );
  }
}
