//
//  <%=class_name %>Test.m
//  

#import "<%= class_name %>Test.h"


@implementation <%= class_name %>Test

- (void)setUp {
  NSMutableSet *allBundles = [[NSMutableSet alloc] init];
  [allBundles addObjectsFromArray:[NSBundle allBundles]];
  [allBundles addObjectsFromArray:[NSBundle allFrameworks]];
  
  managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:[allBundles allObjects]] retain];
  coodinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
  
  managedObjectContext = [[NSManagedObjectContext alloc] init];
  [managedObjectContext setPersistentStoreCoordinator:coodinator];
}

- (void)tearDown
{
  [managedObjectContext release];
  [coodinator release];
  [managedObjectModel release];
}

-(NSEntityDescription *)getEntityNamed:(NSString *)entityName{
  // Get Entity
  NSEntityDescription *entityDescription = [[managedObjectModel entitiesByName] objectForKey:entityName];
  STAssertNotNil( entityDescription, @"%@ description was nil", entityName ); 
  return entityDescription;
}

-(void)checkAttributeEntityName:(NSString *)entityName
                  attributeName:(NSString *)attributeName
                  attributeType:(NSAttributeType)attributeType
                       optional:(BOOL)optional
{
  NSEntityDescription *entityDescription = [self getEntityNamed:entityName];
  
  NSAttributeDescription *attributeDescription = [[entityDescription attributesByName] objectForKey:attributeName];
  STAssertNotNil( attributeDescription, @"%@ attribute was nil", attributeName);
  STAssertTrue( attributeType == [attributeDescription attributeType], @"%@:Found %d expected %d.", attributeName, [attributeDescription attributeType], attributeType);
  // Check if optional
  if (optional)
    STAssertTrue([attributeDescription isOptional], @"%@ is not optional", attributeName);
  else
    STAssertFalse([attributeDescription isOptional], @"%@ is optional", attributeName);
}

-(void)checkRelationshipEntityName:(NSString *)entityName 
                  relationshipName:(NSString *)relationshipName 
                          optional:(BOOL)optional
            relationshipEntityName:(NSString *)relationshipEntityName 
           inverseRelationshipName:(NSString *)inverseRelationshipName
                            toMany:(BOOL)toMany
                          minCount:(NSUInteger)minCount
                          maxCount:(NSUInteger)maxCount
                        deleteRule:(NSDeleteRule)deleteRule{
  // Get Entity
  NSEntityDescription *entityDescription = [[managedObjectModel entitiesByName] objectForKey:entityName];
  STAssertNotNil( entityDescription, @"%@ description was nil", entityName );  
  
  // Get Relationship
  NSRelationshipDescription *relationshipDescription = [[entityDescription relationshipsByName] objectForKey:relationshipName];
  STAssertNotNil(relationshipDescription, @"%@ relationship was nil", relationshipName);
  STAssertTrue(minCount == [relationshipDescription minCount], @"Found %d expected %d", [relationshipDescription minCount], minCount);
  // Check if optional
  if (optional)
    STAssertTrue([relationshipDescription isOptional], @"Relationship is not optional");
  else
    STAssertFalse([relationshipDescription isOptional], @"Relationship is optional");
  
  STAssertTrue(deleteRule == [relationshipDescription deleteRule], @"Found %d", [relationshipDescription deleteRule]);
  
  // Check Destination
  NSEntityDescription *relationshipEntityDescription = [relationshipDescription destinationEntity];
  STAssertNotNil(relationshipEntityDescription, @"%@ entity description is nil");
  STAssertEqualObjects(relationshipEntityName, [relationshipEntityDescription name], @"Found %@", [relationshipEntityDescription name]);
  
  // Check Inverse
  NSRelationshipDescription *inverseRelationshipEntityDescription = [relationshipDescription inverseRelationship];
  STAssertNotNil(inverseRelationshipEntityDescription, @"inverse relationship is nil");
  STAssertEqualObjects(inverseRelationshipName, [inverseRelationshipEntityDescription name], @"Found %@", [inverseRelationshipEntityDescription name]);
}


// Test for SdnList
- (void)testSdnList
{
  NSString *entityName = @"<%=class_name%>";
  NSString *inverseRelationshipName = @"<%= "#{class_name[0].downcase}#{class_name[2..-1]}" %>";
  
  // Test Attributes
  // Attribute: Publish_Date
  [self checkAttributeEntityName:entityName 
                   attributeName:@"Publish_Date" 
                   attributeType:NSStringAttributeType 
                        optional:YES];

  // Test Relationships
  // Relationship: publshInformation
  [self checkRelationshipEntityName:entityName 
                   relationshipName:@"publshInformation" 
                           optional:YES
             relationshipEntityName:@"PublshInformation" 
            inverseRelationshipName:inverseRelationshipName
                             toMany: NO
                           minCount:1
                           maxCount:1
                         deleteRule:NSCascadeDeleteRule];
  
  // Relationship: sdnEntries  
  [self checkRelationshipEntityName:entityName 
                   relationshipName:@"sdnEntries" 
                           optional:YES
             relationshipEntityName:@"SdnEntry" 
            inverseRelationshipName:inverseRelationshipName
                             toMany: YES
                           minCount:0
                           maxCount:1
                         deleteRule:NSCascadeDeleteRule];
}

@end
