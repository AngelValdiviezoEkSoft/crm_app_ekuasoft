class UtilitiesCommon {

  DateTime parseToLocal(String fechaString) {
    if (fechaString.isEmpty) {
      throw ArgumentError("La fecha no puede estar vacía");
    }

    String fechaISO = fechaString.replaceFirst(' ', 'T');

    if (!fechaISO.endsWith('Z')) {
      fechaISO = "${fechaISO}Z";
    }

    DateTime fechaUtc = DateTime.parse(fechaISO);
    return fechaUtc.toLocal();
  }

}