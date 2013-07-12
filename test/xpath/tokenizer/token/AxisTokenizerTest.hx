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
import haxe.unit.TestCase;
import xpath.tokenizer.token.AxisTokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.Token;
import xpath.Axis;


class AxisTokenizerTest extends TestCase {
	
	var axes :Hash<Axis>;
	
	
	function new () {
		super();
		axes = new Hash<Axis>();
		axes.set("ancestor", Ancestor);
		axes.set("ancestor-or-self", AncestorOrSelf);
		axes.set("attribute", Attribute);
		axes.set("child", Child);
		axes.set("descendant", Descendant);
		axes.set("descendant-or-self", DescendantOrSelf);
		axes.set("following", Following);
		axes.set("following-sibling", FollowingSibling);
		axes.set("namespace", Namespace);
		axes.set("parent", Parent);
		axes.set("preceding", Preceding);
		axes.set("preceding-sibling", PrecedingSibling);
		axes.set("self", Self);
	}

	function testGood () {
		for (whitespace in ["", " ", "    "]) {
			for (garbage in ["", "fmnvisfjg-", "cx. ]", "?MVCZ"]) {
				for (extraGarbage in ["", ":"]) {
					for (axisName in axes.keys()) {
						for (whitespace2 in ["", " ", "    "]) {
							var input = new TokenizerInput(
								axisName + whitespace + "::" + whitespace2 + extraGarbage + garbage
							);
							var output = AxisTokenizer.getInstance().tokenize(input);
							
							assertEquals(1, output.result.length);
							assertEquals(
								axisName.length + whitespace.length + 2 + whitespace2.length,
								output.characterLength
							);
							assertTrue(Std.is(output.result[0], AxisToken));
							assertEquals(axes.get(axisName), cast(output.result[0], AxisToken).axis);
						}
						
						var input = new TokenizerInput(
							axisName + whitespace + extraGarbage + garbage
						);
						var output = AxisTokenizer.getInstance().tokenize(input);
						
						assertEquals(1, output.result.length);
						assertEquals(0, output.characterLength);
						assertTrue(Std.is(output.result[0], AxisToken));
						assertEquals(Child, cast(output.result[0], AxisToken).axis);
					}
				}
				
				var input = new TokenizerInput("@" + whitespace + garbage);
				var output = AxisTokenizer.getInstance().tokenize(input);
				
				assertEquals(1, output.result.length);
				assertEquals(1 + whitespace.length, output.characterLength);
				assertTrue(Std.is(output.result[0], AxisToken));
				assertEquals(Attribute, cast(output.result[0], AxisToken).axis);
				
				input = new TokenizerInput(whitespace + garbage);
				output = AxisTokenizer.getInstance().tokenize(input);
				
				assertEquals(1, output.result.length);
				assertEquals(whitespace.length, output.characterLength);
				assertTrue(Std.is(output.result[0], AxisToken));
				assertEquals(Child, cast(output.result[0], AxisToken).axis);
			}
		}
	}
	
}
