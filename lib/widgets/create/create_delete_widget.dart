import 'package:bars/utilities/exports.dart';

class CreateDeleteWidget extends StatelessWidget {
  final VoidCallback onpressed;
  final String text;


  const CreateDeleteWidget({super.key, required this.onpressed, required this.text, });

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Container(
          width: ResponsiveHelper.responsiveHeight(context, 50.0),
          height: ResponsiveHelper.responsiveHeight(context, 50.0),          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onpressed,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                height: ResponsiveHelper.responsiveHeight(context, 40.0),
                width: ResponsiveHelper.responsiveHeight(context, 40.0),
                child: IconButton(
                    icon: Icon(Icons.delete_forever),
                    iconSize: ResponsiveHelper.responsiveHeight(context, 25.0),
                    color: Colors.blue,
                    onPressed: onpressed),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 30.0),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50),
          child: Text(
            text,
            style: TextStyle(color: Colors.grey, fontSize:ResponsiveHelper.responsiveFontSize(context, 12.0),),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
      ],
    )
    ;
  }
}
