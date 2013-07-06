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


package xpath.tokenizer.token;
import Haxe.unit.TestCase;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.TokenizerOutput;
import xpath.tokenizer.token.AbbreviatedStepTokenizer;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;
import xpath.Axis;
import xpath.NodeCategory;


class AbbreviatedStepTokenizerTest extends TestCase {
	
	function testGood () {
		for (whitespace in ["", " ", "      "]) {
			for (xpathStr in [".", ".."]) {
				for (garbage in ["", ",b,ndsjg", "#dsgjg"]) {
					var extraGarbages;
					if (xpathStr == "..") extraGarbages = ["", "."];
					else extraGarbages = [""];
					
					for (extraGarbage in extraGarbages) {
						var input = new TokenizerInput(xpathStr + whitespace + extraGarbage + garbage);
						var output = AbbreviatedStepTokenizer.getInstance().tokenize(input);
						
 						assertEquals(2, output.result.length);
						assertEquals(xpathStr.length + whitespace.length, output.characterLength);
						assertTrue(Std.is(output.result[0], AxisToken));
						if (xpathStr == ".") {
							assertEquals(Self, cast(output.result[0], AxisToken).axis);
						} else {
							assertEquals(Parent, cast(output.result[0], AxisToken).axis);
						}
						assertTrue(Std.is(output.result[1], TypeTestToken));
						assertEquals(Node, cast(output.result[1], TypeTestToken).type);
					}
				}
			}			
		}
	}
	
	function testBad () {
		for (garbage in ["", ",vxcgsfp", "/#vxcbkprsjg"]) {
			var input = new TokenizerInput(garbage);
			
			var caught = false;
			try { 
				var output = AbbreviatedStepTokenizer.getInstance().tokenize(input);
			} catch (exception:ExpectedException) {
				assertEquals(0, exception.position);
				caught = true;
			}
			assertTrue(caught);
		}
	}
	
}
