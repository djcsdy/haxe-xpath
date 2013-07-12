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
import xpath.tokenizer.container.ContainerTokenizerTestBase;
import xpath.tokenizer.container.NodeTestTokenizer;
import xpath.tokenizer.Token;


class NodeTestTokenizerTest extends ContainerTokenizerTestBase {
	
	public function new () {
		super(NodeTestTokenizer.getInstance());
	}
	
	private function testWildcard () {
		doGoodTest("*", [cast(new NameTestToken("*"), Token)]);
	}
	
	private function testNamespaceWildcard () {
		doGoodTest("_abc:*", [
			cast(new NameTestToken("_abc:*"), Token)
		]);
	}
	
	private function testNamespaceName () {
		doGoodTest("GSnskfg:___grsjg-sgj", [
			cast(new NameTestToken("GSnskfg:___grsjg-sgj"), Token)
		]);
	}
	
	private function testTypeTest () {	
		doGoodTest("node()", [cast(new TypeTestToken(Node), Token)]);
		doGoodTest("text ()", [cast(new TypeTestToken(Text), Token)]);
		doGoodTest("comment () ", [cast(new TypeTestToken(Comment), Token)]);
	}

	private function testPITypeTest () {
		doGoodTest("processing-instruction()", [
			cast(new PINameTestToken(), Token)
		]);
		doGoodTest("processing-instruction('dsfgjs')", [
			cast(new PINameTestToken("dsfgjs"), Token)
		]);
		doGoodTest('processing-instruction("sjgjh")', [
			cast(new PINameTestToken("sjgjh"), Token)
		]);
	}
	
	private function testJunk () {	
		doBadTest("-sgsjg-gsgj");
		doBadTest("(hshg)");
		doBadTest("[sgjsg]");
	}

}
