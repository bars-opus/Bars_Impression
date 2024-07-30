import 'package:bars/utilities/exports.dart';

class MoreAboutAccountTypes extends StatelessWidget {
  const MoreAboutAccountTypes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void _navigateToPage(BuildContext context, Widget page) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          TicketPurchasingIcon(
            title: '',
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(
                  Uri.parse('https://www.barsopus.com/refund-policy'))) {
                throw 'Could not launch ';
              }
            },
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(children: [
                TextSpan(
                  text: 'Account types.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextSpan(
                  text:
                      "\n\nThis provides an overview of each account type and helps clarify the categories you may fall under based on the services you offer, especially if you are uncertain about where you fit in",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nArtist.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nArtists are individuals who perform their creative work, often in the visual, literary, or performing arts. In the context of events, they can be painters, sculptors, or interactive artists who contribute to the aesthetic and experience of the event.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nBand.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nBands are groups of musicians who play music together. They may specialize in a variety of genres and provide live music for events, enhancing the atmosphere with their performances.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nBattle Rapper.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nBattle rappers engage in competitive, improvised rap battles against each other, often as part of an entertainment lineup for an event, showcasing their lyrical skills and quick wit.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nBlogger.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nBloggers write and publish content on various topics and may cover events on their platforms, helping to promote and offer insights about the event experience.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nBrand Influencer.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nBrand influencers have significant online followings and can promote events to their audience, helping to increase visibility and credibility through their endorsements.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nChoire.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nChoirs are ensembles of singers who perform vocal music, often in harmonies. They can provide live choral performances at events, adding a touch of elegance and tradition.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nCover Art Designer.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nCover art designers specialize in creating visual artwork for albums, books, and other media. They can design promotional materials for events, such as posters or digital graphics.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nDancer.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nDancers perform choreographed or improvised movements to music. They can be featured in performances at events or provide dance entertainment to engage attendees.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nDJ.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nDJs select and play recorded music for an audience, expertly blending tracks to maintain the energy and atmosphere at events.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nEvent Organizer.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nEvent organizers plan and coordinate all aspects of events, from conception to execution, ensuring a smooth and successful event experience.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nFan.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nFans are enthusiastic supporters of a particular artist, band, or event and can contribute to the atmosphere by their presence and engagement at events.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nInstrumentalist.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nInstrumentalists play musical instruments and can perform solo or as part of an ensemble, providing live music tailored to the event's theme or audience.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nMakeup Artist.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nMakeup artists apply makeup to individuals, enhancing their features for special occasions. They can work on performers or attendees to ensure they look their best for the event..",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nMC (Host).",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nMCs, or hosts, guide the event by introducing performers, engaging the audience, and facilitating the event's flow, ensuring that the event runs smoothly and entertainingly.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nMusic Video Director.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nMusic video directors create visual storytelling to accompany music tracks. They can be involved in producing promotional videos for events.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nPhotographer.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nPhotographers capture moments through images, documenting the event and providing attendees with lasting memories.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nProducer.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nProducers oversee the creation and production of musical tracks or performances and can be involved in organizing event lineups or performances.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nRecord Label.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nRecord labels represent and promote artists and their music. They can work with event organizers to feature their artists at events.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nVideo Vixen.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nVideo vixens are models who appear in music videos or promotional content, often adding a visual allure to the media they are part of.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nCaterers.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nCaterers provide food and beverage services for events, tailoring their offerings to the event's theme and the hosts' preferences.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nSound and Light.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nSound and light technicians manage the audio and visual elements of an event, ensuring high-quality sound for performances and creating lighting that enhances the venue's atmosphere.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: "\n\nDecorator.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text:
                      "\nDecorators design and set up the event space's décor, creating an immersive environment that aligns with the theme and purpose of the event.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ]),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
