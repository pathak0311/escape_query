import 'package:escape_query/get_result_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var queryTypes = ["html", "shell", "path"];
  String selectedQueryType = "html";

  TextEditingController inputFieldController = TextEditingController();

  String outputQuery = "";
  bool isLoading = false;

  late GetResultQuery getResultQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escape Query"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        elevation: 16,
                        child: Container(
                          height: 200,
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0)),
                                  color: Colors.blue,
                                ),
                                child: const Center(
                                    child: Text(
                                  "Info Here",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )),
                                padding: EdgeInsets.all(12.0),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                child: const Text(
                                  "• html method - For escaping HTML Queries\n"
                                  "• shell method - For escaping UNIX shell Queries\n"
                                  "• path method - For escaping UNIX Path Queries",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.info_outline))
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //input headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
                  child: Text(
                    "Input",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, top: 20, bottom: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        style: const TextStyle(
                            fontSize: 22, color: Colors.black87),
                        value: selectedQueryType,
                        items: queryTypes.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? selectedValue) {
                          setState(() {
                            selectedQueryType = selectedValue!;
                          });
                        }),
                  ),
                )
              ],
            ),
            //input field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: inputFieldController.clear,
                        icon: const Icon(Icons.clear)),
                    border: const OutlineInputBorder(),
                    labelText: "Input Query",
                    hintText: "Enter your Query"),
                controller: inputFieldController,
              ),
            ),
            //submit button
            GestureDetector(
              onTap: () {
                //<>/>,test'
                setState(() {
                  isLoading = true;
                  getResultQuery = GetResultQuery(
                      inputFieldController.text, selectedQueryType);
                  getResultQuery.getResultQuery().then((value) {
                    outputQuery = value;
                    setState(() {
                      isLoading = false;
                    });
                  });
                });
              },
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text("</>"),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      color: Colors.amberAccent),
                ),
              ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      //Data Output header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //output text
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Output",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          //copy button
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: outputQuery));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Output Query copied to clipboard"),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.copy,
                                  size: 25,
                                )),
                          )
                        ],
                      ),
                      //output container
                      Container(
                        width: double.maxFinite,
                        height: 200,
                        child: SingleChildScrollView(
                          child: Text(
                            outputQuery,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
