import 'package:flutter/material.dart';
import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sign Demo',
      home: MyHomePage(title: 'Sign Up'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool agreeTerms = false;
  var loading = false;

  onSubmit() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      setState(() {
        loading = true;
      });

      Timer(
          Duration(seconds: 3),
          () => {
                setState(() {
                  loading = false;
                })
              });

      Timer(
          Duration(seconds: 3),
          () => {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Account created successfully!"),
                      backgroundColor: Colors.greenAccent[700]),
                )
              });
    }
  }

  onAgreeTermsCheckboxChanged(value) {
    setState(() {
      agreeTerms = value == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF090723))),
      ),
      body: ScrollableForm(
          formKey: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FullNameFormField(
                controller: nameController,
              ),
              PhoneNumberFormField(
                controller: numberController,
              ),
              EmailFormField(
                controller: emailController,
              ),
              PasswordFormField(
                controller: passwordController,
              ),
              AgreeTermsCheckbox(
                agreeTerms: agreeTerms,
                onChanged: onAgreeTermsCheckboxChanged,
              ),
              SizedBox(
                height: 24,
              ),
              SubmitButton(
                onPressed: agreeTerms ? onSubmit : null,
                loading: loading,
              ),
              SocialNetworkSignIn(),
              const SignInButton()
            ],
          )),
    );
  }
}

class ScrollableForm extends StatelessWidget {
  const ScrollableForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.child,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final Column child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0),
            child: Form(
              key: _formKey,
              child: SafeArea(
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FullNameFormField extends StatelessWidget {
  const FullNameFormField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormContainer(
      label: 'Full Name',
      child: TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.text,
        decoration: TextFormDecoration('Full Name', Icons.person_outline),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Full name is required';
          }
          return null;
        },
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(color: Color(0xFF090723))),
      ),
    );
  }
}

class PhoneNumberFormField extends StatelessWidget {
  PhoneNumberFormField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  final maskFormatter = new MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return TextFormContainer(
      label: 'Your Mobile Number',
      child: TextFormField(
        controller: controller,
        inputFormatters: [maskFormatter],
        keyboardType: TextInputType.number,
        decoration: TextFormDecoration('Mobile Number', Icons.phone_outlined),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Mobile number is required';
          }
          if (value.length != 14) {
            return 'Please provide a mobile number';
          }
          return null;
        },
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(color: Color(0xFF090723))),
      ),
    );
  }
}

class EmailFormField extends StatelessWidget {
  const EmailFormField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormContainer(
      label: 'Your Email',
      child: TextFormField(
        controller: controller,
        decoration: TextFormDecoration('Email', Icons.email_outlined),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          if (!EmailValidator.validate(value)) {
            return 'Please provide a valid email';
          }
          return null;
        },
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(color: Color(0xFF090723))),
      ),
    );
  }
}

class PasswordFormField extends StatelessWidget {
  const PasswordFormField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormContainer(
      label: 'Password',
      child: TextFormField(
        controller: controller,
        decoration: TextFormDecoration('Password', Icons.lock_outline),
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          return null;
        },
        obscureText: true,
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
          color: Color(0xFF090723),
        )),
      ),
    );
  }
}

class AgreeTermsCheckbox extends StatelessWidget {
  const AgreeTermsCheckbox({
    super.key,
    required this.agreeTerms,
    required this.onChanged,
  });

  final bool agreeTerms;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
            child: InkWell(
          onTap: () {
            onChanged(!agreeTerms);
          },
          child: Icon(
            agreeTerms ? Icons.check_box : Icons.check_box_outline_blank,
            size: 32.0,
            color: const Color(0XFF4f00dc),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text.rich(
            TextSpan(
                text: "I agree to the ",
                style: GoogleFonts.poppins(color: const Color(0xFF090723)),
                children: [
                  const TextSpan(
                      text: "terms and conditions",
                      style: TextStyle(decoration: TextDecoration.underline)),
                ]),
          ),
        ),
      ],
    );
  }
}

class SubmitButton extends StatelessWidget {
  SubmitButton({super.key, required this.loading, required this.onPressed});

  final VoidCallback? onPressed;
  bool loading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !loading ? onPressed : () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading)
            Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Create Account',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFF4f00dc),
          minimumSize: const Size.fromHeight(50),
          elevation: 15,
          shadowColor: const Color(0xAA000000),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)))),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text.rich(
          TextSpan(
              text: "Already have an account?  ",
              style: GoogleFonts.poppins(color: const Color(0xFF090723)),
              children: [
                const TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Color(0XFF4f00dc), fontWeight: FontWeight.bold)),
              ]),
        ),
      ),
    );
  }
}

class SocialNetworkSignIn extends StatelessWidget {
  SocialNetworkSignIn({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 16),
          child: Text(
            "OR",
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const IconContainer(
                child: Icon(
              FontAwesomeIcons.google,
              size: 32,
              color: Color(0xFFDB4437),
            )),
            const IconContainer(
                child: Icon(
              FontAwesomeIcons.facebook,
              size: 32,
              color: Color(0xFF3b5998),
            )),
            const IconContainer(
                child: Icon(
              FontAwesomeIcons.apple,
              size: 32,
            )),
          ],
        ),
      ],
    );
  }
}

class IconContainer extends StatelessWidget {
  const IconContainer({
    super.key,
    required this.child,
  });

  final Icon child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
            color: Color(0XFFEEEEEE),
            borderRadius: BorderRadius.all(Radius.circular(32))),
        child: child,
      ),
    );
  }
}

class TextFormContainer extends StatelessWidget {
  const TextFormContainer({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: GoogleFonts.poppins(
                fontSize: 16, color: const Color(0XFFB4B4B4)),
          ),
        ),
        SizedBox(
          child: child,
          height: 75,
        ),
      ],
    );
  }
}

InputDecoration TextFormDecoration(label, icon) {
  return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: Color(0XFFB4B4B4)),
      errorStyle: GoogleFonts.poppins(),
      prefixIcon: Icon(icon, color: const Color(0XFFB4B4B4)),
      contentPadding: EdgeInsets.zero,
      border: const OutlineInputBorder());
}
