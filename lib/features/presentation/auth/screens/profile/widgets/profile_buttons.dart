import 'package:base_flutter/core/base_widgets/custom_button.dart';
import 'package:base_flutter/core/base_widgets/custom_text_button.dart';
import 'package:base_flutter/core/helpers/app_loader_helper.dart';
import 'package:base_flutter/core/resource/color_manager.dart';
import 'package:base_flutter/core/resource/navigation_service.dart';
import 'package:base_flutter/features/repos/base_repo.dart';
import 'package:base_flutter/features/repos/repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../more/screens/change_password/widgets/change_password_body.dart';
import '../../../blocs/change_password_cubit/change_password_cubit.dart';
import '../../../blocs/update_profile_cubit/update_profile_cubit.dart';

class ProfileButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = UpdateProfileCubit.get(context);
    BaseRepo repo = RepoImpl();
    return Column(
      children: [
      cubit.state is UpdateProfileLoading ? AppLoaderHelper.showLoadingView():  CustomButton(
          title: 'حفظ التغييرات',
          onTap: () {
            cubit.updateProfile();
          },
        ),
        CustomTextButton(
          title: 'تغيير كلمة المرور',
          onTap: () {
            NavigationService.navigateTo(BlocProvider(
              create: (context) => ChangePasswordCubit(),
              child: ChangePasswordBody(),
            ),);
          },
          color: ColorManager.black,
        ),
        CustomTextButton(
          title: 'حذف الحساب  ',
          onTap: () async{
         await repo.deleteAcc();
          },
          color: ColorManager.error,
        ),
      ],
    );
  }
}
