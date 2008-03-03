/* haXe XPath
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package xpath.tokenizer;
import haxe.unit.TestCase;
import xpath.tokenizer.ExpectedException;
import xpath.tokenizer.TokenizerError;


class ExpectedExceptionTest extends TestCase {
	
	function testEmpty () :Void {
		var caught = false;
		try {
			var expectedException = new ExpectedException([]);
		} catch (error:TokenizerError) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testToString () :Void {
		var expectedException = new ExpectedException([{
			tokenName: "bananas",
			position: 0
		}]);
		assertEquals(
			"character 0: Expected bananas",
			expectedException.toString()
		);
		
		expectedException = new ExpectedException([{
			tokenName: "apples",
			position: 32
		}, {
			tokenName: "oranges",
			position: 42
		}]);
		assertEquals(
			"character 32: Expected apples, or oranges at character 42",
			expectedException.toString()
		);

		expectedException = new ExpectedException([{
			tokenName: "oranges",
			position: 42
		}, {
			tokenName: "apples",
			position: 32
		}]);
		assertEquals(
			"character 32: Expected apples, or oranges at character 42",
			expectedException.toString()
		);
		
		expectedException = new ExpectedException([{
			tokenName: "apples",
			position: 32
		}, {
			tokenName: "oranges",
			position: 42
		}, {
			tokenName: "bananas",
			position: 32
		}]);
		assertEquals(
			"character 32: Expected apples, or bananas, or oranges " +
			"at character 42"
		, expectedException.toString());
	}
	
}
