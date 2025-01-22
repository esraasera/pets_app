import 'package:flutter/material.dart';
import 'package:your_pets/modules/vaccination_screen.dart';
import 'package:your_pets/shared/components/components.dart';
import 'package:your_pets/styles/colors.dart';

class NotVaccinatedScreen extends StatelessWidget {
  NotVaccinatedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 50,
          elevation: 0.0,
          leading:InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: defaultColor,
            ),
          ),
        ),
        body:Container(
          margin: const EdgeInsets.all(10.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height ,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20.0),
                      color: defaultColor,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Why Vaccines Matter :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context,index) => buildVaccineItem(context,index) ,
                        separatorBuilder:  (context,index) => myDivider(),
                        itemCount: 5,
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: (){
                          navigationTo(context, VaccinationScreen());
                        },
                        child: CircleAvatar(
                          radius: 16.0,
                          backgroundColor: defaultColor,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildVaccineItem(context,index) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 10.0,
      ),
      Text(
        "${vaccinationBenefits[index]['title']}",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
        ),
      ),
      const SizedBox(
        height: 3.0,
      ),
      Text(
        "${vaccinationBenefits[index]['text']}",
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 15.0,
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
    ],
  );
  final List<Map<String, String>> vaccinationBenefits = [
    {
      'title': 'Disease Prevention',
      'text':
      "Vaccines shield pets from severe illnesses such as rabies, parvo virus, distemper, and feline leukemia. These diseases can be fatal and are often highly contagious among animals.",
    },
    {
      'title': 'Zoonotic Disease Protection',
      'text':
      'Some diseases, like rabies, can be transmitted from pets to humans. Vaccinating pets reduces this risk, ensuring the safety of both animals and their owners.',
    },
    {
      'title': 'Community Health',
      'text':
      'Widespread vaccination helps to control outbreaks and maintain the overall health of the pet population in your community.',
    },
    {
      'title': 'Cost-Effectiveness',
      'text':
      'Preventing disease through vaccination is far more affordable than treating serious illnesses, which often require prolonged and intensive medical care.',
    },
    {
      'title': 'Travel and Socialization',
      'text':
      'Vaccinations are often required for pets to travel, attend daycare, or participate in group activities, ensuring they are protected in social settings.',
    },
  ];

}