import 'package:bars/utilities/exports.dart';

class CreateInfoWidget extends StatelessWidget {
  final bool isEditting;
  final String feature;
  final String selectImageInfo;
  final String featureInfo;

  const CreateInfoWidget(
      {super.key,
      required this.isEditting,
      required this.feature,
      required this.selectImageInfo,
      required this.featureInfo});

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _user = _provider.user;
    return isEditting
        ? CreateDeleteWidget(
            text:
                " Provide accurate information.\nRefresh your page to see the effect of your mood punced edited or deleted",
            onpressed: () {},
          )
        : RichText(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
            text: TextSpan(children: [
              TextSpan(
                text: _user!.userName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: selectImageInfo,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                ),
              ),
             
              TextSpan(
                text: featureInfo,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                ),
              ),
            ]),
            textAlign: TextAlign.center);
  }
}
