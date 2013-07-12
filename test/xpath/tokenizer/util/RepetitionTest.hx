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


package xpath.tokenizer.util;
import haxe.unit.TestCase;
import xpath.tokenizer.util.Repetition;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.FakeAnyCharTokenizer;
import xpath.tokenizer.FakeNeverTokenizer;


class RepetitionTest extends TestCase {
    function testAll() {
        var input = new TokenizerInput("     ");

        var tokenizer = new Repetition([
            cast(new FakeAnyCharTokenizer(), Tokenizer),
            new FakeAnyCharTokenizer()
        ]);
        var output = tokenizer.tokenize(input);
        assertEquals(4, output.characterLength);
        assertEquals(4, output.result.length);

        output = tokenizer.tokenize(output.getNextInput());
        assertEquals(0, output.characterLength);
        assertEquals(0, output.result.length);

        tokenizer = new Repetition([
            cast(new FakeNeverTokenizer(), Tokenizer),
            new FakeAnyCharTokenizer()
        ]);
        output = tokenizer.tokenize(input);
        assertEquals(0, output.characterLength);
        assertEquals(0, output.result.length);

        tokenizer = new Repetition([
            cast(new FakeAnyCharTokenizer(), Tokenizer),
            new FakeNeverTokenizer()
        ]);
        output = tokenizer.tokenize(input);
        assertEquals(0, output.characterLength);
        assertEquals(0, output.result.length);
    }
}
