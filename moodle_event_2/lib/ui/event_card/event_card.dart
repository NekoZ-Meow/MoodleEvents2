import 'package:flutter/material.dart';
import 'package:moodle_event_2/ui/event_card/event_card_viewmodel.dart';
import 'package:moodle_event_2/utility/font_utility.dart';
import 'package:provider/provider.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String eventTitle = context.read<EventCardViewModel>().event.title;
    final String eventCourse =
        context.read<EventCardViewModel>().event.courseName;
    final Size cardSize = textSize("", Theme.of(context).textTheme.headline2!);

    return GestureDetector(
      onTap: () => {},
      child: Card(
        child: Container(
          height: cardSize.height * 5,
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            /// タイトルとコース名
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      eventTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  Text(
                    eventCourse,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),

            /// 提出済みかどうかのテキスト
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: context.read<EventCardViewModel>().getSubmitText(),
              ),
            ),

            /// 提出日時を表すウィジェット
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<EventCardViewModel>(
                    builder: (context, viewModel, _) {
                      return Text(viewModel.deadLineString);
                    },
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
