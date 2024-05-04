import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/data/models/reports/objection_report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/error/show_custom_snackbar.dart';
import '../../../core/utills/dimensions.dart';
import '../../controllers/user/user_cubit.dart';

class ObjectionReportsScreen extends StatefulWidget {
  const ObjectionReportsScreen({Key? key}) : super(key: key);

  @override
  State<ObjectionReportsScreen> createState() => _ObjectionReportsScreen();
}

class _ObjectionReportsScreen extends State<ObjectionReportsScreen> {
  TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<UserCubit>()..getObjectionReports(context),
      child: Scaffold(
        backgroundColor: AppColors().backgroundColorScaffold,
        appBar: AppBar(
          backgroundColor: AppColors().backgroundColorScaffold,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors().iconColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppLocalizations.of(context)!.objection_reports,
              style: TextStyles.titleTextStyle),
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is LoadingObjectionReportsState) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors().circularProgressIndicatorColor,
                ),
              );
            }
            if (state is LoadedObjectionReportsState) {
              return state.reports.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.no_Items,
                        style: TextStyles.labelTextStyle,
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (lcontext, index) {
                        return Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              if (isManager || isAdmin)
                                SlidableAction(
                                  onPressed: (BuildContext scontext) {
                                    answerOnnObjectionReport(context,
                                        state.reports[index], state.reports);
                                  },
                                  backgroundColor:
                                      const Color.fromARGB(255, 12, 148, 48),
                                  foregroundColor: Colors.white,
                                  icon: Icons.manage_accounts_rounded,
                                  label: AppLocalizations.of(context)!.answer,
                                ),
                            ],
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.5, color: AppColors().borderColor),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius10 / 2),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.email} : ${state.reports[index].email}",
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${AppLocalizations.of(context)!.content} :",
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                Text(
                                  state.reports[index].content,
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${AppLocalizations.of(context)!.answer} :",
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                Text(
                                  state.reports[index].answer,
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${AppLocalizations.of(context)!.date} :  ${state.reports[index].date}",
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${AppLocalizations.of(context)!.response_date} :  ${state.reports[index].responseDate}",
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.no_accounts_outlined,
                                color: AppColors().iconColor),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: state.reports.length,
                    );
            }
            if (state is ErrorLoadingObjectionReportsState) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.error_something_wrong,
                  style: TextStyles.labelTextStyle,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  answerOnnObjectionReport(mcontext, report, reports) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, localSetState) {
            return AlertDialog(
              scrollable: true,
              title: Text(
                  AppLocalizations.of(mcontext)!.answer_an_objection_report),
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(mcontext)!.write_your_answer),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller,
                      maxLines: null,
                      minLines: 1,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(mcontext)!
                              .write_your_answer_here),
                    ),
                  ]),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.close),
                  onPressed: () {
                    controller.clear();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.send),
                  onPressed: () {
                    BlocProvider.of<UserCubit>(mcontext,listen: false).answerOnObjectionReport(
                      mcontext,
                      ObjectionReportModel(
                          id: report.id,
                          email: report.email,
                          content: report.content,
                          answer: controller.text,
                          date: report.date,
                          responseDate: report.responseDate),
                      reports,
                    );
                    
                    controller.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }),
        );
      },
    );
  }

  showError(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.failureSnackBar(message));
  }
}
