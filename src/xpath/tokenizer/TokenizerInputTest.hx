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


package xpath.tokenizer;
import Haxe.unit.TestCase;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.Token;
import xpath.tokenizer.TokenizerException;


class TokenizerInputTest extends TestCase {
	
	function testNew () {
		var tokenizerInput = new TokenizerInput("bananas");
		assertEquals(0, tokenizerInput.position);
		assertEquals("bananas", tokenizerInput.query);
		
		tokenizerInput = new TokenizerInput("bananas", 4);
		assertEquals(4, tokenizerInput.position);
		assertEquals("bananas", tokenizerInput.query);
	}
	
	function testGetOutput () {
		var tokenizerInput = new TokenizerInput("bananas");
		var tokenizerOutput = tokenizerInput.getOutput([], 0);
		assertEquals(0, tokenizerOutput.characterLength);
		assertEquals(0, tokenizerOutput.result.length);
		tokenizerInput = tokenizerOutput.getNextInput();
		assertEquals(0, tokenizerInput.position);
		assertEquals("bananas", tokenizerInput.query);
		
		tokenizerOutput = tokenizerInput.getOutput([
			cast(new FakeToken1(), Token)
		], 2);
		assertEquals(2, tokenizerOutput.characterLength);
		assertEquals(1, tokenizerOutput.result.length);
		assertTrue(Std.is(tokenizerOutput.result[0], FakeToken1));
		tokenizerInput = tokenizerOutput.getNextInput();
		assertEquals(2, tokenizerInput.position);
		assertEquals("bananas", tokenizerInput.query);
		
		tokenizerOutput = tokenizerInput.getOutput([
			cast(new FakeToken1(), Token), new FakeToken2()
		]);
		assertEquals(5, tokenizerOutput.characterLength);
		assertEquals(2, tokenizerOutput.result.length);
		assertTrue(Std.is(tokenizerOutput.result[0], FakeToken1));
		assertTrue(Std.is(tokenizerOutput.result[1], FakeToken2));
		
		var caught = false;
		try {
			tokenizerOutput.getNextInput();
		} catch (exception:TokenizerException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}

private class FakeToken1 implements Token {
	
	public function new () {
	}
	
}

private class FakeToken2 implements Token {
	
	public function new () {
	}
	
}
