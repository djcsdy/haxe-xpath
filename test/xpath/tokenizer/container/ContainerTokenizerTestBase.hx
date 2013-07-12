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


package xpath.tokenizer.container;
import haxe.unit.TestCase;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;


class ContainerTokenizerTestBase extends TestCase {
    var tokenizer:Tokenizer;


    function new(tokenizer:Tokenizer) {
        super();
        this.tokenizer = tokenizer;
    }

    function doGoodTest(query:String, expectedResult:Array<Token>) {
        var input = new TokenizerInput(query);
        var output = tokenizer.tokenize(input);

        assertEquals(query.length, output.characterLength);
        assertEquals(expectedResult.length, output.result.length);

        var expectedIterator = expectedResult.iterator();
        var actualIterator = output.result.iterator();
        for (i in 0...output.result.length) {
            var expectedToken = expectedIterator.next();
            var actualToken = actualIterator.next();
            assertEquals(
                Type.getClass(expectedToken),
                Type.getClass(actualToken)
            );
            for (field in Reflect.fields(expectedToken)) {
                assertEquals(
                    Reflect.field(expectedToken, field),
                    Reflect.field(actualToken, field)
                );
            }
        }
    }

    private function doBadTest(query:String) {
        var input = new TokenizerInput(query);

        var caught = false;
        try {
            tokenizer.tokenize(input);
        } catch (e:ExpectedException) {
            caught = true;
        }
        assertTrue(caught);
    }

    private function doIncompleteTest(query:String) {
        var input = new TokenizerInput(query);
        var output = tokenizer.tokenize(input);
        assertTrue(output.characterLength < query.length);
    }
}
