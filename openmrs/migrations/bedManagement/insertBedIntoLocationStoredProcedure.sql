DROP PROCEDURE IF EXISTS insertBedIntoLocation;
#
CREATE PROCEDURE insertBedIntoLocation
   (
      IN bedNumber nvarchar(30),
      IN locationName nvarchar(50),
      IN rowNumber nvarchar(20),
      IN columnNumber nvarchar(20)
   )
BEGIN
    SELECT location_id INTO @locationId FROM location WHERE location.name=locationName;
    INSERT INTO bed (bed_number, bed_type_id, uuid, creator, date_created, voided) VALUES (bedNumber, 1, uuid(), 1, NOW(), FALSE);
    SELECT bed.bed_id INTO @bedId FROM bed LEFT OUTER JOIN bed_location_map ON bed_location_map.bed_id = bed.bed_id WHERE bed.bed_number=bedNumber AND bed_location_map.location_id IS NULL;
    INSERT INTO bed_location_map(location_id, row_number, column_number, bed_id) VALUES (@locationId, rowNumber, columnNumber, @bedId);
END
#
