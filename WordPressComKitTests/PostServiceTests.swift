import XCTest
import OHHTTPStubs
import WordPressComKit

class PostServiceTests: XCTestCase {
    var subject: PostService!
    
    override func setUp() {
        super.setUp()
        
        subject = PostService()
    }
    
    override func tearDown() {
        super.tearDown()
        
        subject = nil
        OHHTTPStubs.removeAllStubs()
    }
    
    func testFetchPost() {
        stub(condition: isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/sites/57773116/posts/57")) { _ in
            let stubPath = OHPathForFile("post.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject: "application/json" as AnyObject])
        }
        
        let expectation = self.expectation(description: "FetchMe")
        
        subject.fetchPost(57, siteID: 57773116) { (post, error) -> Void in
            expectation.fulfill()
            
            XCTAssertNotNil(post)
            XCTAssertNil(error)
            
            XCTAssertEqual(57, post!.ID)
            XCTAssertEqual(57773116, post!.siteID)
            XCTAssertNotNil(post!.created)
            XCTAssertNotNil(post!.updated)
            XCTAssertEqual("Test post from the REST API", post!.title)
            XCTAssertEqual("https://ardwptest1.wordpress.com/2015/11/27/test-post-from-the-rest-api/", post!.URL?.absoluteString)
            XCTAssertEqual("http://wp.me/p3Upqs-V", post!.shortURL?.absoluteString)
            XCTAssertEqual("<p>And this is the content of the post.</p>\n", post!.content)
            XCTAssertEqual("https://ardwptest1.wordpress.com/2015/11/27/test-post-from-the-rest-api/", post!.guid)
            XCTAssertEqual("publish", post!.status)
            XCTAssertNil(post!.featuredImageURL)
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testCreatePost() {
        stub(condition: isMethodPOST() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/sites/57773116/posts/new")) { _ in
            let stubPath = OHPathForFile("post-new.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject: "application/json" as AnyObject])
        }
        let expectation = self.expectation(description: "CreateMe")
        
        subject.createPost(siteID: 57773116, status: "publish", title: "Test Post", body: "This is the body.") { post, error in
            expectation.fulfill()
            
            XCTAssertNotNil(post)
            XCTAssertNil(error)
            
            XCTAssertEqual(57, post!.ID)
            XCTAssertEqual(57773116, post!.siteID)
            XCTAssertNotNil(post!.created)
            XCTAssertNotNil(post!.updated)
            XCTAssertEqual("Test post from the REST API", post!.title)
            XCTAssertEqual("https://ardwptest1.wordpress.com/2015/11/27/test-post-from-the-rest-api/", post!.URL?.absoluteString)
            XCTAssertEqual("http://wp.me/p3Upqs-V", post!.shortURL?.absoluteString)
            XCTAssertEqual("<p>And this is the content of the post.</p>\n", post!.content)
            XCTAssertEqual("https://ardwptest1.wordpress.com/2015/11/27/test-post-from-the-rest-api/", post!.guid)
            XCTAssertEqual("publish", post!.status)
            XCTAssertNil(post!.featuredImageURL)
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
  
    
}
