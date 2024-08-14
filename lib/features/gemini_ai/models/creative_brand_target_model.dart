// import 'package:cloud_firestore/cloud_firestore.dart';

// class CreativeBrandTargetModel {
//   final String userId;
//   final String creativeStyle;
//   final String creativeStyleSuggestion;
//   final String inspiration;
//   final String inspirationSuggestion;
//   final String admiredWork;
//   final String admiredWorkSuggestion;
//   final String audiencePerception;
//   final String audiencePerceptionSuggestion;
//   final String keyValues;
//   final String keyValuesSuggestion;
//   final String currentBrandStatus;
//   final String currentBrandStatusSuggestion;
//   final String satisfaction;
//   final String satisfactionSuggestion;
//   final String improvement;
//   final String improvementSuggestion;
//   final String marketingStrategies;
//   final String marketingStrategiesSuggestion;
//   final String promotionChannels;
//   final String promotionChannelsSuggestion;
//   final String brandPersonality;
//   final String brandPersonalitySuggestion;
//   final String toneOfVoice;
//   final String toneOfVoiceSuggestion;
//   final String visualElements;
//   final String visualElementsSuggestion;
//   final String visualStyle;
//   final String visualStyleSuggestion;
//   final String feedback;
//   final String feedbackSuggestion;
//   final String specificImprovements;
//   final String specificImprovementsSuggestion;
//   final String skills;
//   final String skillsSuggestion;
//   final String projects;
//   final String projectsSuggestion;
//   final String clients;
//   final String clientsSuggestion;
//   final String shortTermGoals;
//   final String shortTermGoalsSuggestion;
//   final String longTermGoals;
//   final String longTermGoalsSuggestion;

//     final String targetAudience;
//     final String targetAudienceSuggestion;



//     final String brandVison;
//     final String brandVisonSuggestion;

    


//   CreativeBrandTargetModel({
//     required this.userId,
//     required this.creativeStyle,
//     required this.creativeStyleSuggestion,
//     required this.inspiration,
//     required this.inspirationSuggestion,
//     required this.admiredWork,
//     required this.admiredWorkSuggestion,
//     required this.audiencePerception,
//     required this.audiencePerceptionSuggestion,
//     required this.keyValues,
//     required this.keyValuesSuggestion,
//     required this.currentBrandStatus,
//     required this.currentBrandStatusSuggestion,
//     required this.satisfaction,
//     required this.satisfactionSuggestion,
//     required this.improvement,
//     required this.improvementSuggestion,
//     required this.marketingStrategies,
//     required this.marketingStrategiesSuggestion,
//     required this.promotionChannels,
//     required this.promotionChannelsSuggestion,
//     required this.brandPersonality,
//     required this.brandPersonalitySuggestion,
//     required this.toneOfVoice,
//     required this.toneOfVoiceSuggestion,
//     required this.visualElements,
//     required this.visualElementsSuggestion,
//     required this.visualStyle,
//     required this.visualStyleSuggestion,
//     required this.feedback,
//     required this.feedbackSuggestion,
//     required this.specificImprovements,
//     required this.specificImprovementsSuggestion,
//     required this.skills,
//     required this.skillsSuggestion,
//     required this.projects,
//     required this.projectsSuggestion,
//     required this.clients,
//     required this.clientsSuggestion,
//     required this.shortTermGoals,
//     required this.shortTermGoalsSuggestion,
//     required this.longTermGoals,
//     required this.longTermGoalsSuggestion,
//      required this.targetAudience,
//       required this.targetAudienceSuggestion,
//        required this.brandVison,
//         required this.brandVisonSuggestion,
//   });

//   factory CreativeBrandTargetModel.fromDoc(DocumentSnapshot doc) {
//     return CreativeBrandTargetModel(
//       userId: doc.id,
     
//       creativeStyle: doc['creativeStyle'] ?? '',
//       creativeStyleSuggestion: doc['creativeStyleSuggestion'] ?? '',
//       inspiration: doc['inspiration'] ?? '',
//       inspirationSuggestion: doc['inspirationSuggestion'] ?? '',
//       admiredWork: doc['admiredWork'] ?? '',
//       admiredWorkSuggestion: doc['admiredWorkSuggestion'] ?? '',
//       audiencePerception: doc['audiencePerception'] ?? '',
//       audiencePerceptionSuggestion: doc['audiencePerceptionSuggestion'] ?? '',
//       keyValues: doc['keyValues'] ?? '',
//       keyValuesSuggestion: doc['keyValuesSuggestion'] ?? '',
//       currentBrandStatus: doc['currentBrandStatus'] ?? '',
//       currentBrandStatusSuggestion: doc['currentBrandStatusSuggestion'] ?? '',
//       satisfaction: doc['satisfaction'] ?? '',
//       satisfactionSuggestion: doc['satisfactionSuggestion'] ?? '',
//       improvement: doc['improvement'] ?? '',
//       improvementSuggestion: doc['improvementSuggestion'] ?? '',
//       marketingStrategies: doc['marketingStrategies'] ?? '',
//       marketingStrategiesSuggestion: doc['marketingStrategiesSuggestion'] ?? '',
//       promotionChannels: doc['promotionChannels'] ?? '',
//       promotionChannelsSuggestion: doc['promotionChannelsSuggestion'] ?? '',
//       brandPersonality: doc['brandPersonality'] ?? '',
//       brandPersonalitySuggestion: doc['brandPersonalitySuggestion'] ?? '',
//       toneOfVoice: doc['toneOfVoice'] ?? '',
//       toneOfVoiceSuggestion: doc['toneOfVoiceSuggestion'] ?? '',
//       visualElements: doc['visualElements'] ?? '',
//       visualElementsSuggestion: doc['visualElementsSuggestion'] ?? '',
//       visualStyle: doc['visualStyle'] ?? '',
//       visualStyleSuggestion: doc['visualStyleSuggestion'] ?? '',
//       feedback: doc['feedback'] ?? '',
//       feedbackSuggestion: doc['feedbackSuggestion'] ?? '',
//       specificImprovements: doc['specificImprovements'] ?? '',
//       specificImprovementsSuggestion: doc['specificImprovementsSuggestion'] ?? '',
//       skills: doc['skills'] ?? '',
//       skillsSuggestion: doc['skillsSuggestion'] ?? '',
//       projects: doc['projects'] ?? '',
//       projectsSuggestion: doc['projectsSuggestion'] ?? '',
//       clients: doc['clients'] ?? '',
//       clientsSuggestion: doc['clientsSuggestion'] ?? '',
//       shortTermGoals: doc['shortTermGoals'] ?? '',
//       shortTermGoalsSuggestion: doc['shortTermGoalsSuggestion'] ?? '',
//       longTermGoals: doc['longTermGoals'] ?? '',
//       longTermGoalsSuggestion: doc['longTermGoalsSuggestion'] ?? '',

//        targetAudience: doc['targetAudience'] ?? '',
//       targetAudienceSuggestion: doc['targetAudienceSuggestion'] ?? '',
//        brandVison: doc['brandVison'] ?? '',
//         brandVisonSuggestion: doc['brandVisonSuggestion'] ?? '',
//     );
//   }

//   factory CreativeBrandTargetModel.fromJson(Map<String, dynamic> json) {
//     return CreativeBrandTargetModel(
//       userId: json['userId'] ?? '',
//         targetAudience: json['targetAudience'] ?? '',
//           targetAudienceSuggestion: json['targetAudienceSuggestion'] ?? '',

      
//         brandVison: json['brandVison'] ?? '',
//   brandVisonSuggestion: json['brandVisonSuggestion'] ?? '',


//       creativeStyle: json['creativeStyle'] ?? '',
//       creativeStyleSuggestion: json['creativeStyleSuggestion'] ?? '',
//       inspiration: json['inspiration'] ?? '',
//       inspirationSuggestion: json['inspirationSuggestion'] ?? '',
//       admiredWork: json['admiredWork'] ?? '',
//       admiredWorkSuggestion: json['admiredWorkSuggestion'] ?? '',
//       audiencePerception: json['audiencePerception'] ?? '',
//       audiencePerceptionSuggestion: json['audiencePerceptionSuggestion'] ?? '',
//       keyValues: json['keyValues'] ?? '',
//       keyValuesSuggestion: json['keyValuesSuggestion'] ?? '',
//       currentBrandStatus: json['currentBrandStatus'] ?? '',
//       currentBrandStatusSuggestion: json['currentBrandStatusSuggestion'] ?? '',
//       satisfaction: json['satisfaction'] ?? '',
//       satisfactionSuggestion: json['satisfactionSuggestion'] ?? '',
//       improvement: json['improvement'] ?? '',
//       improvementSuggestion: json['improvementSuggestion'] ?? '',
//       marketingStrategies: json['marketingStrategies'] ?? '',
//       marketingStrategiesSuggestion: json['marketingStrategiesSuggestion'] ?? '',
//       promotionChannels: json['promotionChannels'] ?? '',
//       promotionChannelsSuggestion: json['promotionChannelsSuggestion'] ?? '',
//       brandPersonality: json['brandPersonality'] ?? '',
//       brandPersonalitySuggestion: json['brandPersonalitySuggestion'] ?? '',
//       toneOfVoice: json['toneOfVoice'] ?? '',
//       toneOfVoiceSuggestion: json['toneOfVoiceSuggestion'] ?? '',
//       visualElements: json['visualElements'] ?? '',
//       visualElementsSuggestion: json['visualElementsSuggestion'] ?? '',
//       visualStyle: json['visualStyle'] ?? '',
//       visualStyleSuggestion: json['visualStyleSuggestion'] ?? '',
//       feedback: json['feedback'] ?? '',
//       feedbackSuggestion: json['feedbackSuggestion'] ?? '',
//       specificImprovements: json['specificImprovements'] ?? '',
//       specificImprovementsSuggestion: json['specificImprovementsSuggestion'] ?? '',
//       skills: json['skills'] ?? '',
//       skillsSuggestion: json['skillsSuggestion'] ?? '',
//       projects: json['projects'] ?? '',
//       projectsSuggestion: json['projectsSuggestion'] ?? '',
//       clients: json['clients'] ?? '',
//       clientsSuggestion: json['clientsSuggestion'] ?? '',
//       shortTermGoals: json['shortTermGoals'] ?? '',
//       shortTermGoalsSuggestion: json['shortTermGoalsSuggestion'] ?? '',
//       longTermGoals: json['longTermGoals'] ?? '',
//       longTermGoalsSuggestion: json['longTermGoalsSuggestion'] ?? '',

   
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'targetAudience': targetAudience,
//       'targetAudienceSuggestion': targetAudienceSuggestion,
//       'brandVison': brandVison,
//       'brandVisonSuggestion': brandVisonSuggestion,
//       'creativeStyle': creativeStyle,
//       'creativeStyleSuggestion': creativeStyleSuggestion,
//       'inspiration': inspiration,
//       'inspirationSuggestion': inspirationSuggestion,
//       'admiredWork': admiredWork,
//       'admiredWorkSuggestion': admiredWorkSuggestion,
//       'audiencePerception': audiencePerception,
//       'audiencePerceptionSuggestion': audiencePerceptionSuggestion,
//       'keyValues': keyValues,
//       'keyValuesSuggestion': keyValuesSuggestion,
//       'currentBrandStatus': currentBrandStatus,
//       'currentBrandStatusSuggestion': currentBrandStatusSuggestion,
//       'satisfaction': satisfaction,
//       'satisfactionSuggestion': satisfactionSuggestion,
//       'improvement': improvement,
//       'improvementSuggestion': improvementSuggestion,
//       'marketingStrategies': marketingStrategies,
//       'marketingStrategiesSuggestion': marketingStrategiesSuggestion,
//       'promotionChannels': promotionChannels,
//       'promotionChannelsSuggestion': promotionChannelsSuggestion,
//       'brandPersonality': brandPersonality,
//       'brandPersonalitySuggestion': brandPersonalitySuggestion,
//       'toneOfVoice': toneOfVoice,
//       'toneOfVoiceSuggestion': toneOfVoiceSuggestion,
//       'visualElements': visualElements,
//       'visualElementsSuggestion': visualElementsSuggestion,
//       'visualStyle': visualStyle,
//       'visualStyleSuggestion': visualStyleSuggestion,
//       'feedback': feedback,
//       'feedbackSuggestion': feedbackSuggestion,
//       'specificImprovements': specificImprovements,
//       'specificImprovementsSuggestion': specificImprovementsSuggestion,
//       'skills': skills,
//       'skillsSuggestion': skillsSuggestion,
//       'projects': projects,
//       'projectsSuggestion': projectsSuggestion,
//       'clients': clients,
//       'clientsSuggestion': clientsSuggestion,
//       'shortTermGoals': shortTermGoals,
//       'shortTermGoalsSuggestion': shortTermGoalsSuggestion,
//       'longTermGoals': longTermGoals,
//       'longTermGoalsSuggestion': longTermGoalsSuggestion,
//     };
//   }
// }
