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


package xpath.tokenizer.util;
import haxe.unit.TestCase;
import xpath.tokenizer.util.Sequence;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.TokenizerOutput;
import xpath.tokenizer.ExpectedException;
import xpath.tokenizer.FakeAnyCharTokenizer;
import xpath.tokenizer.FakeNeverTokenizer;


class SequenceTest extends TestCase {
	
	function testAll () {
		var input = new TokenizerInput("     ");
		
		var tokenizer = new Sequence([
			cast(new FakeAnyCharTokenizer(), Tokenizer),
			new FakeAnyCharTokenizer()
		]);
		var output = tokenizer.tokenize(input);
		assertEquals(2, output.characterLength);
		assertEquals(2, output.result.length);
		
		output = tokenizer.tokenize(output.getNextInput());
		assertEquals(2, output.characterLength);
		assertEquals(2, output.result.length);
		
		var caught = false;
		try {
			output = tokenizer.tokenize(output.getNextInput());
		} catch (exception:ExpectedException) {
			caught = true;
			assertEquals(5, exception.position);
		}
		assertTrue(caught);
		
		tokenizer = new Sequence([
			cast(new FakeNeverTokenizer(),  Tokenizer),
			new FakeAnyCharTokenizer()
		]);
		caught = false;
		try {
			output = tokenizer.tokenize(input);
		} catch (exception:ExpectedException) {
			caught = true;
			assertEquals(0, exception.position);
		}
		assertTrue(caught);
		
		tokenizer = new Sequence([
			cast(new FakeAnyCharTokenizer(), Tokenizer),
			new FakeNeverTokenizer()
		]);
		caught = false;
		try {
			output = tokenizer.tokenize(input);
		} catch (exception:ExpectedException) {
			caught = true;
			assertEquals(1, exception.position);
		}
		assertTrue(caught);
	}
	
}
