public without sharing class CommunityAccess {

	private static final Boolean IsCheckedUser = (!Test.isRunningTest() && UserInfo.getUserType() != 'Guest');
	public static final String AccessViolationException = 'Access Restricted';

	// Access
	public static void ThrowAccessException(Schema.DescribeSObjectResult soDescribe) {
		throw new CommunityAccessException(
			AccessViolationException,
			CommunityAccessException.ExceptionType.OBJECT_ACCESS_VIOLATION,
			CommunityAccessException.ExceptionReason.GENERIC,
			soDescribe.getName(),
			NULL
		);
	}

	// Insert
	public static Database.SaveResult InsertWithoutSharing(sObject obj, String err, Schema.DescribeFieldResult[] fields) {
		FLSAccessControllerWithSharing acws = new FLSAccessControllerWithSharing();
		String notCreateableFLS = acws.hasNotCreateableFLS(fields);
		if (IsCheckedUser && notCreateableFLS != NULL) {
			throw new CommunityAccessException(
				AccessViolationException,
				CommunityAccessException.ExceptionType.FIELD_ACCESS_VIOLATION,
				CommunityAccessException.ExceptionReason.NO_CREATE,
				obj.getSObjectType().getDescribe().getName(),
				notCreateableFLS
			);
		}
		return Database.insert(obj);
	}

	public static Database.SaveResult[] InsertWithoutSharing(sObject[] objs, String err, Schema.DescribeFieldResult[] fields) {
		if(objs.isEmpty()){
			return null;
		}
		FLSAccessControllerWithSharing acws = new FLSAccessControllerWithSharing();
		String notCreateableFLS = acws.hasNotCreateableFLS(fields);
		if (IsCheckedUser && notCreateableFLS != NULL) {
			throw new CommunityAccessException(
				AccessViolationException,
				CommunityAccessException.ExceptionType.FIELD_ACCESS_VIOLATION,
				CommunityAccessException.ExceptionReason.NO_CREATE,
				objs[0].getSObjectType().getDescribe().getName(),
				notCreateableFLS
			);
		}
		return Database.insert(objs);
	}

	// Update
	public static Database.SaveResult UpdateWithoutSharing(sObject obj, String err, Schema.DescribeFieldResult[] fields) {
		FLSAccessControllerWithSharing acws = new FLSAccessControllerWithSharing();
		String notUpdateableFLS = !obj.getSObjectType().getDescribe().isCustom() ? acws.hasNotCreateableFLS(fields) : acws.hasNotUpdateableFLS(fields);
		if (IsCheckedUser && notUpdateableFLS != NULL) {
			throw new CommunityAccessException(
				AccessViolationException,
				CommunityAccessException.ExceptionType.FIELD_ACCESS_VIOLATION,
				CommunityAccessException.ExceptionReason.NO_UPDATE,
				obj.getSObjectType().getDescribe().getName(),
				notUpdateableFLS
			);
		}
		return Database.update(obj);
	}
	public static Database.SaveResult[] UpdateWithoutSharing(sObject[] objs, String err, Schema.DescribeFieldResult[] fields) {
		if(objs.isEmpty()){
			return null;
		}
		FLSAccessControllerWithSharing acws = new FLSAccessControllerWithSharing();
		String notUpdateableFLS = !objs[0].getSObjectType().getDescribe().isCustom() ? acws.hasNotCreateableFLS(fields) : acws.hasNotUpdateableFLS(fields);
		if (IsCheckedUser && notUpdateableFLS != NULL) {
			throw new CommunityAccessException(
				AccessViolationException,
				CommunityAccessException.ExceptionType.FIELD_ACCESS_VIOLATION,
				CommunityAccessException.ExceptionReason.NO_UPDATE,
				objs[0].getSObjectType().getDescribe().getName(),
				notUpdateableFLS
			);
		}
		return Database.update(objs);
	}

	// Upsert
	public static Database.UpsertResult UpsertWithoutSharing(sObject obj, String err, Schema.DescribeFieldResult[] fields) {
		FLSAccessControllerWithSharing acws = new FLSAccessControllerWithSharing();
		String notCreateableFLS = obj.Id == NULL ? acws.hasNotCreateableFLS(fields) : NULL;
		String notUpdateableFLS = obj.Id == NULL ? NULL : acws.hasNotUpdateableFLS(fields);
		//String notUpdateableFLS = !obj.getSObjectType().getDescribe().isCustom() ? notCreateableFLS : acws.hasNotUpdateableFLS(fields);
		if (IsCheckedUser && notCreateableFLS != NULL || notUpdateableFLS != NULL) {
			throw new CommunityAccessException(
				AccessViolationException,
				CommunityAccessException.ExceptionType.FIELD_ACCESS_VIOLATION,
				(notCreateableFLS!=NULL) ? CommunityAccessException.ExceptionReason.NO_CREATE : CommunityAccessException.ExceptionReason.NO_UPDATE,
				obj.getSObjectType().getDescribe().getName(),
				(notCreateableFLS!=NULL) ? notCreateableFLS : notUpdateableFLS
			);
		}
		return Database.upsert(obj);
	}
	public static Database.UpsertResult[] UpsertWithoutSharing(sObject[] objs, String err, Schema.DescribeFieldResult[] fields) {
		if(objs.isEmpty()){
			return null;
		}
		FLSAccessControllerWithSharing acws = new FLSAccessControllerWithSharing();
		String notCreateableFLS = acws.hasNotCreateableFLS(fields);
		String notUpdateableFLS = !objs[0].getSObjectType().getDescribe().isCustom() ? notCreateableFLS : acws.hasNotUpdateableFLS(fields);
		if (IsCheckedUser && notCreateableFLS != NULL || notUpdateableFLS != NULL) {
			throw new CommunityAccessException(
				AccessViolationException,
				CommunityAccessException.ExceptionType.FIELD_ACCESS_VIOLATION,
				(notCreateableFLS!=NULL) ? CommunityAccessException.ExceptionReason.NO_CREATE : CommunityAccessException.ExceptionReason.NO_UPDATE,
				objs[0].getSObjectType().getDescribe().getName(),
				(notCreateableFLS!=NULL) ? notCreateableFLS : notUpdateableFLS
			);
		}
		return Database.upsert(objs);
	}

	// Delete
	public static Database.DeleteResult DeleteWithoutSharing(sObject obj, String err) {
		FLSAccessControllerWithSharing acws = new FLSAccessControllerWithSharing();
		Boolean isObjectDeletable = (!obj.getSObjectType().getDescribe().isCustom()) ? acws.isObjectCreateable(obj) : acws.isObjectDeletable(obj);
		if (IsCheckedUser && isObjectDeletable == false) {
			throw new CommunityAccessException(
				AccessViolationException,
				CommunityAccessException.ExceptionType.OBJECT_ACCESS_VIOLATION,
				CommunityAccessException.ExceptionReason.NO_DELETE,
				obj.getSObjectType().getDescribe().getName(),
				''
			);
		}
		return Database.delete(obj);
	}
	public static Database.DeleteResult[] DeleteWithoutSharing(sObject[] objs, String err) {
		if(objs.isEmpty()){
			return null;
		}
		FLSAccessControllerWithSharing acws = new FLSAccessControllerWithSharing();
		Boolean isObjectsDeletable = (!objs[0].getSObjectType().getDescribe().isCustom()) ? acws.isObjectsCreateable(objs) : acws.isObjectsDeletable(objs);
		if (IsCheckedUser && isObjectsDeletable == false) {
			throw new CommunityAccessException(
				AccessViolationException,
				CommunityAccessException.ExceptionType.OBJECT_ACCESS_VIOLATION,
				CommunityAccessException.ExceptionReason.NO_DELETE,
				objs[0].getSObjectType().getDescribe().getName(),
				''
			);
		}
		return Database.delete(objs);
	}

	private with sharing class FLSAccessControllerWithSharing {
		public String hasNotCreateableFLS(Schema.DescribeFieldResult[] fields) {
			String result = NULL;
			for (Schema.DescribeFieldResult field : fields) {
				Boolean isCreateable = field.isCreateable();
				if (!isCreateable) {
					result = field.getName();
					break;
				}
			}
			return result;
		}
		public String hasNotUpdateableFLS(Schema.DescribeFieldResult[] fields) {
			String result = NULL;
			for (Schema.DescribeFieldResult field : fields) {
				// For Master-Detail fields check for Creatable instead of Updateable access
				Boolean isUpdateable = (field.getRelationshipOrder() != NULL) ? field.isCreateable() : field.isUpdateable();
				if (!isUpdateable) {
					result = field.getName();
					break;
				}
			}
			return result;
		}
		public Boolean isObjectCreateable(sObject obj) {
			return obj.getSObjectType().getDescribe().isCreateable();
		}
		public Boolean isObjectsCreateable(sObject[] objs) {
			return objs[0].getSObjectType().getDescribe().isCreateable();
		}
		public Boolean isObjectDeletable(sObject obj) {
			return obj.getSObjectType().getDescribe().isDeletable();
		}
		public Boolean isObjectsDeletable(sObject[] objs) {
			return objs[0].getSObjectType().getDescribe().isDeletable();
		}
	}
}