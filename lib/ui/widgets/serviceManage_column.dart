import 'package:flutter/material.dart';

class ServiceManageColumn extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final String price;
  final double width;
  final String photo;
  final Function()? delete;
  ServiceManageColumn(
      {required this.price,
      required this.title,
      required this.onTap,
      required this.width,
      required this.photo,
      required this.delete});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          fit: BoxFit.cover, image: NetworkImage(photo))),
                ),
                SizedBox(width: 30),
                Container(
                  width: width * 0.25,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
                SizedBox(width: width / 12),
                Container(
                  width: 130,
                  child: Text(
                    price.split(".")[0],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                SizedBox(width: 50),
                IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      size: 40,
                      color: Colors.red,
                    ),
                    onPressed: delete)
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
