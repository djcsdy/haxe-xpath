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
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.token.DeepStepDelimiterTokenizer;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;
import xpath.Axis;
import xpath.NodeCategory;


class DeepStepDelimiterTokenizerTest extends TestCase {
    function testGood() {
        for (whitespace in ["", " ", "   "]) {
            for (garbage in ["", "fsgpjg", "/fgjsdf", "///sfgkosg"]) {
                var input = new TokenizerInput("//" + whitespace + garbage);
                var output = DeepStepDelimiterTokenizer.getInstance().tokenize(input);

                assertEquals(4, output.result.length);
                assertEquals(2 + whitespace.length, output.characterLength);
                assertTrue(Std.is(output.result[0], StepDelimiterToken));
                assertTrue(Std.is(output.result[1], AxisToken));
                assertTrue(Std.is(output.result[2], TypeTestToken));
                assertTrue(Std.is(output.result[3], StepDelimiterToken));
                assertEquals(DescendantOrSelf, cast(output.result[1], AxisToken).axis);
                assertEquals(Node, cast(output.result[2], TypeTestToken).type);
            }
        }
    }

    function testBad() {
        for (whitespace in ["", " ", "   "]) {
            for (garbage in ["", "fsgpjg", "/fgjsdf"]) {
                var input = new TokenizerInput(whitespace + garbage);

                var caught = false;
                try {
                    DeepStepDelimiterTokenizer.getInstance().tokenize(input);
                } catch (exception:ExpectedException) {
                    caught = true;
                    assertEquals(0, exception.position);
                }
                assertTrue(caught);
            }
        }
    }
}
