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
import xpath.tokenizer.TokenizerOutput;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.Token;
import xpath.tokenizer.TokenizerException;


class TokenizerOutputTest extends TestCase {
	
	function testAll () :Void {
		var tokenizerOutput = new TokenizerOutput([], 0, null);
		assertTrue(tokenizerOutput.isComplete());
		assertEquals(0, tokenizerOutput.characterLength);
		assertEquals(0, tokenizerOutput.result.length);
		var caught = false;
		try {
			tokenizerOutput.getNextInput();
		} catch (exception:TokenizerException) {
			caught = true;
		}
		assertTrue(caught);
		
		var nextInput = new TokenizerInput("bananas", 5);
		tokenizerOutput = new TokenizerOutput(
			[ cast(new FakeToken(), Token) ], 3, nextInput
		);
		assertFalse(tokenizerOutput.isComplete());
		assertEquals(3, tokenizerOutput.characterLength);
		assertEquals(1, tokenizerOutput.result.length);
		assertTrue(Std.is(tokenizerOutput.result[0], FakeToken));
		assertEquals(nextInput, tokenizerOutput.getNextInput());
	}
	
}

private class FakeToken implements Token {
	
	public function new () {
	}
	
}
