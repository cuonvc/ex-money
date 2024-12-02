import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Sự kiện của Bloc
abstract class CounterEvent {}
class UpdateCounter extends CounterEvent {
  final int newCounterValue;
  UpdateCounter(this.newCounterValue);
}
// Trạng thái của Bloc
class CounterState {
  final int counter;
  CounterState(this.counter);
}
// Bloc xử lý sự kiện và cập nhật trạng thái
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)); // Khởi tạo với giá trị ban đầu là 0
  @override
  Future<void> mapEventToState(CounterEvent event) async {
    if (event is UpdateCounter) {
// Cập nhật giá trị counter dựa trên giá trị truyền từ event
      emit(CounterState(event.newCounterValue));
    }
  }
}
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: CounterScreen(),
      ),
    );
  }
}
class CounterScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloc Counter Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
// BlocBuilder với buildWhen để kiểm tra sự thay đổi trạng thái
            BlocBuilder<CounterBloc, CounterState>(
              buildWhen: (previous, current) {
// Chỉ rebuild khi counter thay đổi
                return previous.counter != current.counter;
              },
              builder: (context, state) {
                return Text(
                  'Counter: ${state.counter}', // Hiển thị giá trị counter
                  style: TextStyle(fontSize: 24),
                );
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter a number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
// Truyền giá trị từ TextField vào Event
                final int value = int.tryParse(_controller.text) ?? 0;
                context.read<CounterBloc>().add(UpdateCounter(value));
              },
              child: Text('Update Counter'),
            ),
          ],
        ),
      ),
    );
  }
}