class EventData {
  final String id;
  final String email;
  final String name;
  final String location;
  final String remark;
  final String fromTime;
  final String endTime;
  final int repetition;
  final int eventType;

  const EventData(
    this.id, 
    this.email, 
    this.name, 
    this.location, 
    this.remark, 
    this.fromTime, 
    this.endTime, 
    this.repetition, 
    this.eventType
  );
}