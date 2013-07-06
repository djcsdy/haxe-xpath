/* Haxe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
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


package xpath.value;
import haxe.unit.TestCase;
import xpath.value.XPathString;
import xpath.value.XPathNodeSet;
import xpath.EvaluationException;


class XPathStringTest extends TestCase {
	
	function testGetBool () {
		for (string in [ "abcsd", "false", "FALSE", "null", "0" ]) {
			var xPathString = new XPathString(string);
			assertTrue(xPathString.getBool());
		}
		
		var xPathString = new XPathString("");
		assertFalse(xPathString.getBool());
	}
	
	function testGetFloat () {
		for (string in [ "jgs", "  3392k", "uf3832985", "", "1..2" ]) {
			var xPathString = new XPathString(string);
			assertTrue(Math.isNaN(xPathString.getFloat()));
		}
		
		for (string in [ "0", "1", "0.1234", "3983.3249783" ]) {
			for (wsl in [ "", " ", "   " ]) {
				for (wsr in [ "", " ", "   " ]) {
					var xPathString = new XPathString(wsl + string + wsr);
					assertEquals(Std.parseFloat(string), xPathString.getFloat());
					for (wsm in [ "", " ", "   " ]) {
						xPathString = new XPathString(wsl + "-" + wsm + string + wsr);
						assertEquals(-Std.parseFloat(string), xPathString.getFloat());
					}
				}
			}
		}
	}
	
	function testGetString () {
		for (string in [ "", "dsfhsg" ]) {
			var xPathString = new XPathString(string);
			assertEquals(string, xPathString.getString());
		}
	}
	
	function testEquals () {
		for (left in [ "", "ajifij", " ajifij" ]) {
			var xPathLeft = new XPathString(left);
			for (right in [ "", "ajifij", "ajifij " ]) {
				var xPathRight = new XPathString(right);
				assertEquals(
					left == right,
					xPathLeft.equals(xPathRight).getBool()
				);
				assertEquals(
					left == right,
					xPathRight.equals(xPathLeft).getBool()
				);
			}
		}
	}
	
	function testNotEqual () {
		for (left in [ "", "ajifij", " ajifij" ]) {
			var xPathLeft = new XPathString(left);
			for (right in [ "", "ajifij", "ajifij " ]) {
				var xPathRight = new XPathString(right);
				assertEquals(
					left != right,
					xPathLeft.notEqual(xPathRight).getBool()
				);
				assertEquals(
					left != right,
					xPathRight.notEqual(xPathLeft).getBool()
				);
			}
		}
	}
	
	function testUnion () {
		var caught = false;
		try {
			new XPathString("abc").union(new XPathNodeSet([]));
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}
